import 'dart:async';

import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatRepo _chatRepo;

  ChatCubit(this._chatRepo) : super(ChatInit());
  StreamSubscription<List<MessageModel>>? _subscription;
  List<MessageModel> messages = [];
  RoomModel? room;
  bool isSending = false;

  Future<void> getRoom(String roomID) async {
    emit(GetRoomLoading());
    final result = await _chatRepo.getRoom(roomID);
    result.fold((failure) => emit(GetRoomError(failure.message)), (room) {
      this.room = room;
      emit(GetRoomSuccess(room));
    });
  }

  void getMessage(String roomID) {
    emit(GetMessageLoading());
    _subscription?.cancel();
    _subscription = _chatRepo
        .getMessages(roomID)
        .listen(
          (msgs) {
            messages = msgs;
            if (isSending) {
              emit(SendMessageLoading(msgs: msgs));
            } else {
              emit(GetMessageSuccess(msgs));
            }
          },
          onError: (error) {
            emit(GetMessageError(error.toString()));
          },
        );
  }

  Future<void> sendMessage(MessageModel msg) async {
    if (isSending) return;
    isSending = true;
    emit(SendMessageLoading());
    final res = await _chatRepo.sendMessage(msg);
    isSending = false;
    res.fold(
      (f) => emit(SendMessageError(f.message)),
      (_) => emit(SendMessageSuccess()),
    );
  }

  Future<void> deleteRoom(String roomID) async {
    await _subscription?.cancel();
    _subscription = null;
    emit(DeleteRoomLoading());
    final res = await _chatRepo.deleteRoom(roomID);
    if (isClosed) return;
    res.fold(
      (f) {
        emit(DeleteRoomError(f.message));
        getMessage(roomID);
      },
      (_) => emit(DeleteRoomSuccess()),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

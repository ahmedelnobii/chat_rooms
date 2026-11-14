import 'dart:async';

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
  bool isSending = false;

  void getMessage(String roomID) {
    emit(GetMessageLoading());
    _subscription?.cancel();
    _subscription = _chatRepo
        .getMessages(roomID)
        .listen(
          (msgs) {
            messages = msgs;
            emit(GetMessageSuccess(msgs));
          },
          onError: (error) {
            emit(GetMessageError(error.toString()));
          },
        );
  }

  Future<bool> sendMessage(MessageModel msg) async {
    if (isSending) return false;
    isSending = true;
    emit(SendMessageLoading());
    final res = await _chatRepo.sendMessage(msg);
    isSending = false;
    return res.fold(
      (f) {
        emit(SendMessageError(f.message));
        return false;
      },
      (_) {
        emit(SendMessageSuccess());
        return true;
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

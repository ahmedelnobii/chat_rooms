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
  StreamSubscription<RoomModel>? _roomSubscription;
  List<MessageModel> messages = [];
  RoomModel? room;
  bool isSending = false;

  String? _activeRoomID;
  String? _activeUserID;
  String? _activeUserName;
  bool _hasLeftPresence = false;

  Future<void> getRoom(String roomID) async {
    emit(GetRoomLoading());
    final result = await _chatRepo.getRoom(roomID);
    if (isClosed) return;
    result.fold((failure) => emit(GetRoomError(failure.message)), (room) {
      this.room = room;
      emit(GetRoomSuccess(room));
    });
  }

  void watchRoom(String roomID) {
    _roomSubscription?.cancel();
    _roomSubscription = _chatRepo.watchRoom(roomID).listen(
      (updatedRoom) {
        if (isClosed) return;
        room = updatedRoom;
        emit(GetRoomSuccess(updatedRoom));
      },
      onError: (Object error) {
        if (isClosed) return;
        if (room == null) {
          emit(GetRoomError(error.toString()));
        }
      },
    );
  }

  Future<void> enterRoomPresence({
    required String roomID,
    required String userID,
    required String userName,
  }) async {
    if (roomID.isEmpty || userID.isEmpty) return;
    _activeRoomID = roomID;
    _activeUserID = userID;
    _activeUserName = userName;
    _hasLeftPresence = false;
    await _chatRepo.joinRoomPresence(
      roomID: roomID,
      userID: userID,
      userName: userName,
    );
  }

  Future<void> leaveRoomPresence() async {
    if (_hasLeftPresence) return;
    final roomID = _activeRoomID;
    final userID = _activeUserID;
    if (roomID == null ||
        roomID.isEmpty ||
        userID == null ||
        userID.isEmpty) {
      return;
    }
    _hasLeftPresence = true;
    await _chatRepo.leaveRoomPresence(roomID: roomID, userID: userID);
  }

  Future<void> rejoinRoomPresenceIfNeeded() async {
    final roomID = _activeRoomID;
    final userID = _activeUserID;
    final userName = _activeUserName;
    if (roomID == null ||
        userID == null ||
        userName == null ||
        roomID.isEmpty ||
        userID.isEmpty) {
      return;
    }
    _hasLeftPresence = false;
    await _chatRepo.joinRoomPresence(
      roomID: roomID,
      userID: userID,
      userName: userName,
    );
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
    _hasLeftPresence = true;
    await _subscription?.cancel();
    _subscription = null;
    await _roomSubscription?.cancel();
    _roomSubscription = null;
    emit(DeleteRoomLoading());
    final res = await _chatRepo.deleteRoom(roomID);
    if (isClosed) return;
    res.fold(
      (f) {
        emit(DeleteRoomError(f.message));
        getMessage(roomID);
        watchRoom(roomID);
      },
      (_) => emit(DeleteRoomSuccess()),
    );
  }

  @override
  Future<void> close() async {
    unawaited(leaveRoomPresence());
    await _subscription?.cancel();
    await _roomSubscription?.cancel();
    return super.close();
  }
}

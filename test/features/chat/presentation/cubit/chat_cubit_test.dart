import 'dart:async';

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads and stores room details', () async {
    final messageStream = StreamController<List<MessageModel>>.broadcast(
      sync: true,
    );
    final room = RoomModel(
      creatorId: 'creator',
      creatorName: 'Creator',
      roomID: 'room',
      roomName: 'Room name',
      description: 'Room description',
    );
    final cubit = ChatCubit(
      _FakeChatRepo(
        messageStream.stream,
        Completer<Either<Failer, void>>(),
        roomResult: Right(room),
      ),
    );

    await cubit.getRoom('room');

    expect(cubit.room, same(room));
    expect(cubit.state, isA<GetRoomSuccess>());
    expect((cubit.state as GetRoomSuccess).room.roomName, 'Room name');

    await cubit.close();
    await messageStream.close();
  });

  test(
    'keeps send loading until an offline send failure is reported',
    () async {
      final messageStream = StreamController<List<MessageModel>>.broadcast(
        sync: true,
      );
      final sendResult = Completer<Either<Failer, void>>();
      final cubit = ChatCubit(_FakeChatRepo(messageStream.stream, sendResult));
      final message = MessageModel(
        content: 'Hello',
        senderName: 'Sender',
        roomID: 'room',
        senderID: 'sender',
        createdAt: DateTime(2026),
      );

      cubit.getMessage('room');
      final sending = cubit.sendMessage(message);

      messageStream.add([message..isPending = true]);

      expect(cubit.state, isA<SendMessageLoading>());
      expect(
        (cubit.state as SendMessageLoading).msgs?.single.isPending,
        isTrue,
      );
      expect(cubit.messages, [message]);

      sendResult.complete(Left(Failer('offline')));

      await sending;
      expect(cubit.state, isA<SendMessageError>());
      expect((cubit.state as SendMessageError).msg, 'offline');

      await cubit.close();
      await messageStream.close();
    },
  );

  test('deletes room and emits DeleteRoomSuccess', () async {
    final messageStream = StreamController<List<MessageModel>>.broadcast(
      sync: true,
    );
    final repo = _FakeChatRepo(
      messageStream.stream,
      Completer<Either<Failer, void>>(),
    );
    final cubit = ChatCubit(repo);

    await cubit.deleteRoom('room-123');

    expect(repo.deletedRoomID, 'room-123');
    expect(cubit.state, isA<DeleteRoomSuccess>());

    await cubit.close();
    await messageStream.close();
  });

  test('tracks enter and leave room presence', () async {
    final messageStream = StreamController<List<MessageModel>>.broadcast(
      sync: true,
    );
    final repo = _FakeChatRepo(
      messageStream.stream,
      Completer<Either<Failer, void>>(),
    );
    final cubit = ChatCubit(repo);

    await cubit.enterRoomPresence(
      roomID: 'room-1',
      userID: 'user-1',
      userName: 'Ahmed',
    );
    expect(repo.joinedUserID, 'user-1');
    expect(repo.joinedUserName, 'Ahmed');

    await cubit.leaveRoomPresence();
    expect(repo.leftUserID, 'user-1');

    await cubit.close();
    await messageStream.close();
  });
}

class _FakeChatRepo implements ChatRepo {
  final Stream<List<MessageModel>> messages;
  final Completer<Either<Failer, void>> sendResult;
  final Either<Failer, RoomModel>? roomResult;
  String? deletedRoomID;
  String? joinedUserID;
  String? joinedUserName;
  String? leftUserID;

  _FakeChatRepo(this.messages, this.sendResult, {this.roomResult});

  @override
  Future<Either<Failer, RoomModel>> getRoom(String roomID) async =>
      roomResult ?? Left(Failer('Room not found'));

  @override
  Stream<RoomModel> watchRoom(String roomID) => const Stream.empty();

  @override
  Future<Either<Failer, void>> joinRoomPresence({
    required String roomID,
    required String userID,
    required String userName,
  }) async {
    joinedUserID = userID;
    joinedUserName = userName;
    return const Right(null);
  }

  @override
  Future<Either<Failer, void>> leaveRoomPresence({
    required String roomID,
    required String userID,
  }) async {
    leftUserID = userID;
    return const Right(null);
  }

  @override
  Stream<List<MessageModel>> getMessages(String roomID) => messages;

  @override
  Future<Either<Failer, void>> sendMessage(MessageModel message) =>
      sendResult.future;

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async {
    deletedRoomID = roomID;
    return const Right(null);
  }
}

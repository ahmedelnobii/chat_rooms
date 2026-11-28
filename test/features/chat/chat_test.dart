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
  test('loads room details and emits GetRoomSuccess', () async {
    final room = RoomModel(
      creatorId: 'creator-1',
      creatorName: 'Creator',
      roomID: 'room-1',
      roomName: 'Flutter Room',
      description: 'Room description',
    );
    final repo = _FakeChatRepo(roomResult: Right(room));
    final cubit = ChatCubit(repo);

    await cubit.getRoom('room-1');

    expect(cubit.room, same(room));
    expect(cubit.state, isA<GetRoomSuccess>());
    await cubit.close();
  });

  test('streams messages and sends new message', () async {
    final repo = _FakeChatRepo();
    final cubit = ChatCubit(repo);
    final msg = MessageModel(
      content: 'Hello world',
      senderName: 'Ahmed',
      roomID: 'room-1',
      senderID: 'u-1',
      createdAt: DateTime.utc(2026, 11, 28),
    );

    cubit.getMessage('room-1');
    repo.messageStream.add([msg]);

    expect(cubit.messages, [msg]);
    expect(cubit.state, isA<GetMessageSuccess>());

    await cubit.sendMessage(msg);
    expect(cubit.state, isA<SendMessageSuccess>());

    await cubit.close();
    await repo.close();
  });

  test('tracks enter and leave room presence and deletes room', () async {
    final repo = _FakeChatRepo();
    final cubit = ChatCubit(repo);

    await cubit.enterRoomPresence(
      roomID: 'room-1',
      userID: 'u-1',
      userName: 'Ahmed',
    );
    expect(repo.joinedUserID, 'u-1');

    await cubit.leaveRoomPresence();
    expect(repo.leftUserID, 'u-1');

    await cubit.deleteRoom('room-1');
    expect(repo.deletedRoomID, 'room-1');
    expect(cubit.state, isA<DeleteRoomSuccess>());

    await cubit.close();
    await repo.close();
  });
}

class _FakeChatRepo implements ChatRepo {
  final messageStream = StreamController<List<MessageModel>>.broadcast(
    sync: true,
  );
  final Either<Failer, RoomModel>? roomResult;
  String? joinedUserID;
  String? leftUserID;
  String? deletedRoomID;

  _FakeChatRepo({this.roomResult});

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
  Stream<List<MessageModel>> getMessages(String roomID) => messageStream.stream;

  @override
  Future<Either<Failer, void>> sendMessage(MessageModel message) async =>
      const Right(null);

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async {
    deletedRoomID = roomID;
    return const Right(null);
  }

  Future<void> close() => messageStream.close();
}

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/create_room/data/repo/create_room_repo.dart';
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_cubit.dart';
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final room = RoomModel(
    creatorId: 'u-1',
    creatorName: 'Ahmed',
    roomName: 'Flutter Club',
    description: 'Discuss Flutter & Dart',
  );

  test('createRoom emits CreateRoomSuccess when repository succeeds', () async {
    final repo = _FakeCreateRoomRepo(const Right(null));
    final cubit = CreateRoomCubit(repo);

    await cubit.createRoom(room);

    expect(repo.createdRoom, same(room));
    expect(cubit.state, isA<CreateRoomSuccess>());
    await cubit.close();
  });

  test('createRoom emits CreateRoomError when repository fails', () async {
    final repo = _FakeCreateRoomRepo(Left(Failer('Could not create room')));
    final cubit = CreateRoomCubit(repo);

    await cubit.createRoom(room);

    expect(cubit.state, isA<CreateRoomError>());
    expect((cubit.state as CreateRoomError).msg, 'Could not create room');
    await cubit.close();
  });
}

class _FakeCreateRoomRepo implements CreateRoomRepo {
  final Either<Failer, void> result;
  RoomModel? createdRoom;

  _FakeCreateRoomRepo(this.result);

  @override
  Future<Either<Failer, void>> createRoom(RoomModel room) async {
    createdRoom = room;
    return result;
  }
}

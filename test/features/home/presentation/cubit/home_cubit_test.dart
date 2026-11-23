import 'dart:async';

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads both room streams and cancels them when closed', () async {
    final allRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
    final myRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
    final cubit = HomeCubit(_FakeHomeRepo(allRooms.stream, myRooms.stream));
    final room = RoomModel(
      creatorId: 'creator',
      creatorName: 'Creator',
      roomID: 'room',
      roomName: 'Room',
      description: 'Description',
    );

    await cubit.loadRooms();
    allRooms.add([room]);
    myRooms.add([room]);

    expect(cubit.state.allRooms, [room]);
    expect(cubit.state.myRooms, [room]);
    expect(cubit.state.isLoadingAllRooms, isFalse);
    expect(cubit.state.isLoadingMyRooms, isFalse);

    await cubit.close();

    expect(allRooms.hasListener, isFalse);
    expect(myRooms.hasListener, isFalse);
    await allRooms.close();
    await myRooms.close();
  });

  test('deletes room via repository', () async {
    final allRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
    final myRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
    final repo = _FakeHomeRepo(allRooms.stream, myRooms.stream);
    final cubit = HomeCubit(repo);

    final deleted = await cubit.deleteRoom('room-456');

    expect(deleted, isTrue);
    expect(repo.deletedRoomID, 'room-456');
    expect(cubit.state.isDeletingRoom, isFalse);

    await cubit.close();
    await allRooms.close();
    await myRooms.close();
  });
}

class _FakeHomeRepo implements HomeRepo {
  final Stream<List<RoomModel>> allRooms;
  final Stream<List<RoomModel>> myRooms;
  String? deletedRoomID;

  _FakeHomeRepo(this.allRooms, this.myRooms);

  @override
  Stream<List<RoomModel>> getAllRooms() => allRooms;

  @override
  Stream<List<RoomModel>> getMyRooms() => myRooms;

  @override
  Future<Either<Failer, bool>> verifyRoomPassword(
    String roomID,
    String password,
  ) async => const Right(true);

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async {
    deletedRoomID = roomID;
    return const Right(null);
  }
}

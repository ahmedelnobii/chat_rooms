import 'dart:async';

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeCubit loads room streams and deletes room', () async {
    final repo = _FakeHomeRepo();
    final cubit = HomeCubit(repo);
    final room = RoomModel(
      creatorId: 'creator',
      creatorName: 'Creator',
      roomID: 'room-1',
      roomName: 'Room',
      description: 'Description',
    );

    await cubit.loadRooms();
    repo.allRooms.add([room]);
    repo.myRooms.add([room]);

    expect(cubit.state.allRooms, [room]);
    expect(cubit.state.myRooms, [room]);

    final deleted = await cubit.deleteRoom('room-1');
    expect(deleted, isTrue);
    expect(repo.deletedRoomID, 'room-1');

    await cubit.close();
    await repo.close();
  });

  test('RoomPasswordCubit verifies password and handles empty/wrong input', () async {
    final repo = _FakeHomeRepo(passwordValid: true);
    final cubit = RoomPasswordCubit(repo);

    await cubit.verifyRoomPassword('room-1', '   ');
    expect(cubit.state, isA<RoomPasswordInitial>());
    expect(
      (cubit.state as RoomPasswordInitial).message,
      'Please enter the room password.',
    );

    await cubit.verifyRoomPassword('room-1', 'secret');
    expect(cubit.state, isA<RoomPasswordSuccess>());

    await cubit.close();
    await repo.close();
  });
}

class _FakeHomeRepo implements HomeRepo {
  final allRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
  final myRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
  final bool passwordValid;
  String? deletedRoomID;

  _FakeHomeRepo({this.passwordValid = true});

  @override
  Stream<List<RoomModel>> getAllRooms() => allRooms.stream;

  @override
  Stream<List<RoomModel>> getMyRooms() => myRooms.stream;

  @override
  Future<Either<Failer, bool>> verifyRoomPassword(
    String roomID,
    String password,
  ) async => Right(passwordValid);

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async {
    deletedRoomID = roomID;
    return const Right(null);
  }

  Future<void> close() async {
    await allRooms.close();
    await myRooms.close();
  }
}

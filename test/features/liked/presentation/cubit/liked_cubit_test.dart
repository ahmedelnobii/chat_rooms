import 'dart:async';

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('streams liked rooms and toggles them in the repository', () async {
    final repo = _FakeLikedRepo();
    final cubit = LikedCubit(repo);
    final room = RoomModel(
      roomID: 'room-id',
      creatorId: 'creator-id',
      creatorName: 'Creator',
      roomName: 'Room',
      description: 'Room description',
    );

    await cubit.loadLikedRooms();
    repo.publish(const []);
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.rooms, isEmpty);

    await cubit.toggleLike(room);
    expect(repo.likedRoomIDs, contains('room-id'));
    expect(cubit.state.containsRoom('room-id'), isTrue);

    await cubit.toggleLike(room);
    expect(repo.likedRoomIDs, isEmpty);
    expect(cubit.state.containsRoom('room-id'), isFalse);

    await cubit.close();
    await repo.close();
  });

  test(
    'reports rooms without ids instead of writing invalid documents',
    () async {
      final repo = _FakeLikedRepo();
      final cubit = LikedCubit(repo);
      final room = RoomModel(
        creatorId: 'creator-id',
        creatorName: 'Creator',
        roomName: 'Room',
        description: 'Room description',
      );

      await cubit.loadLikedRooms();
      repo.publish(const []);
      await cubit.toggleLike(room);

      expect(repo.likedRoomIDs, isEmpty);
      expect(cubit.state.error, contains('no ID'));

      await cubit.close();
      await repo.close();
    },
  );
}

class _FakeLikedRepo implements LikedRepo {
  final _likedRooms = StreamController<List<RoomModel>>.broadcast(sync: true);
  final List<RoomModel> _rooms = [];

  List<String?> get likedRoomIDs => _rooms.map((room) => room.roomID).toList();

  void publish(List<RoomModel> rooms) {
    _rooms
      ..clear()
      ..addAll(rooms);
    _likedRooms.add(List.unmodifiable(_rooms));
  }

  @override
  Stream<List<RoomModel>> getLikedRooms() => _likedRooms.stream;

  @override
  Future<Either<Failer, void>> addLikedRoom(RoomModel room) async {
    _rooms.add(room);
    _likedRooms.add(List.unmodifiable(_rooms));
    return const Right(null);
  }

  @override
  Future<Either<Failer, void>> removeLikedRoom(String roomID) async {
    _rooms.removeWhere((room) => room.roomID == roomID);
    _likedRooms.add(List.unmodifiable(_rooms));
    return const Right(null);
  }

  Future<void> close() => _likedRooms.close();
}

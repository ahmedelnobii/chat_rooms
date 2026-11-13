import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/create_room/data/ceate_room_data_source/remote/create_room_remote_data_source.dart';
import 'package:chat_rooms/features/create_room/data/repo/create_room_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: CreateRoomRepo)
class CreateRoomRepoImpl implements CreateRoomRepo {
  final CreateRoomRemoteDataSource _createRoomRemoteDataSource;
  CreateRoomRepoImpl(this._createRoomRemoteDataSource);
  @override
  Future<Either<Failer, void>> createRoom(RoomModel room) async {
    try {
      await _createRoomRemoteDataSource.createRoom(room);
      return Right(Unit);
    } catch (e) {
      return Left(Failer(e.toString()));
    }
  }
}

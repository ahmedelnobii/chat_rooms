import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:dartz/dartz.dart';

abstract class LikedRepo {
  Stream<List<RoomModel>> getLikedRooms();
  Future<Either<Failer, void>> addLikedRoom(RoomModel room);
  Future<Either<Failer, void>> removeLikedRoom(String roomID);
}

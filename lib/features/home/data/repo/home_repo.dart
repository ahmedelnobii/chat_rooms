import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Stream<List<RoomModel>> getMyRooms();
  Stream<List<RoomModel>> getAllRooms();
  Future<Either<Failer, bool>> verifyRoomPassword(
    String roomID,
    String password,
  );
  Future<Either<Failer, void>> deleteRoom(String roomID);
}

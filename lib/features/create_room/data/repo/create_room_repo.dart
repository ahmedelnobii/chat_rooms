import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
@singleton
abstract class CreateRoomRepo {
  Future<Either<Failer, void>> createRoom(RoomModel room);
}

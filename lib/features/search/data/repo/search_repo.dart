import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepo {
  Future<Either<Failer, List<RoomModel>>> searchRooms(String query);
}

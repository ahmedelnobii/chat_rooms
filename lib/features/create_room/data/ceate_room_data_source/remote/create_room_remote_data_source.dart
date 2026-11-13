import 'package:chat_rooms/core/models/room_model.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class CreateRoomRemoteDataSource {
  Future<void> createRoom(RoomModel room);
}

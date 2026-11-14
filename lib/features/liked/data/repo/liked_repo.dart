import 'package:chat_rooms/core/models/room_model.dart';

abstract class LikedRepo {
  Stream<List<RoomModel>> getLikedRooms();
  Future<void> addLikedRoom(RoomModel room);
  Future<void> removeLikedRoom(String roomID);
}

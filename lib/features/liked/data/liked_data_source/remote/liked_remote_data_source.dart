import 'package:chat_rooms/core/models/room_model.dart';

abstract class LikedRemoteDataSource {
  Stream<List<RoomModel>> getLikedRooms();
  Future<void> addLikedRoom(RoomModel room);
  Future<void> removeLikedRoom(String roomID);
}

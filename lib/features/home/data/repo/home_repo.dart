import 'package:chat_rooms/core/models/room_model.dart';

abstract class HomeRepo {
  Stream<List<RoomModel>> getMyRooms();
  Stream<List<RoomModel>> getAllRooms();
  Future<bool> verifyRoomPassword(String roomID, String password);
}

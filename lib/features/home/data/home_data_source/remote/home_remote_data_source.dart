import 'package:chat_rooms/core/models/room_model.dart';

abstract class HomeRemoteDataSource {
  Stream<List<RoomModel>> getMyRooms();
  Stream<List<RoomModel>> getAllRooms();
}

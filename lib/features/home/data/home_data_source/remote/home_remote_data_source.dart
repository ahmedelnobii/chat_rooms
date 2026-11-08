import 'package:chat_rooms/features/home/data/models/room_model.dart';

abstract class HomeRemoteDataSource {
  Stream<List<RoomModel>> getMyRooms();
  Stream<List<RoomModel>> getAllRooms();
}

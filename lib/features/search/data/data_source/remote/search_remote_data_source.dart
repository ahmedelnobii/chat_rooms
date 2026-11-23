import 'package:chat_rooms/core/models/room_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<RoomModel>> searchRooms(String query);
}

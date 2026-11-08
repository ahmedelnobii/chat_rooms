import 'package:chat_rooms/features/home/data/home_data_source/remote/home_remote_data_source.dart';
import 'package:chat_rooms/core/models/room_model.dart';

class HomeFirestoreDataSource implements HomeRemoteDataSource {
  @override
  Stream<List<RoomModel>> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }

  @override
  Stream<List<RoomModel>> getMyRooms() {
    // TODO: implement getMyRooms
    throw UnimplementedError();
  }
}

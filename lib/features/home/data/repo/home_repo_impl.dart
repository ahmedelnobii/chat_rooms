import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/home_data_source/remote/home_remote_data_source.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepoImpl(this._homeRemoteDataSource);

  @override
  Stream<List<RoomModel>> getAllRooms() {
    return _homeRemoteDataSource.getAllRooms();
  }

  @override
  Future<bool> verifyRoomPassword(String roomID, String password) {
    return _homeRemoteDataSource.verifyRoomPassword(roomID, password);
  }

  @override
  Stream<List<RoomModel>> getMyRooms() {
    return _homeRemoteDataSource.getMyRooms();
  }
}

import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/liked/data/liked_data_source/remote/liked_remote_data_source.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: LikedRepo)
class LikedRepoImpl implements LikedRepo {
  final LikedRemoteDataSource _likedRemoteDataSource;

  LikedRepoImpl(this._likedRemoteDataSource);

  @override
  Stream<List<RoomModel>> getLikedRooms() {
    return _likedRemoteDataSource.getLikedRooms();
  }

  @override
  Future<void> addLikedRoom(RoomModel room) {
    return _likedRemoteDataSource.addLikedRoom(room);
  }

  @override
  Future<void> removeLikedRoom(String roomID) {
    return _likedRemoteDataSource.removeLikedRoom(roomID);
  }
}

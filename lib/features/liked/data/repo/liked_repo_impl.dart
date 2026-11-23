import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/liked/data/liked_data_source/remote/liked_remote_data_source.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failer, void>> addLikedRoom(RoomModel room) async {
    try {
      await _likedRemoteDataSource.addLikedRoom(room);
      return const Right(null);
    } catch (error) {
      return Left(Failer(_cleanError(error)));
    }
  }

  @override
  Future<Either<Failer, void>> removeLikedRoom(String roomID) async {
    try {
      await _likedRemoteDataSource.removeLikedRoom(roomID);
      return const Right(null);
    } catch (error) {
      return Left(Failer(_cleanError(error)));
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('Bad state: ', '');
  }
}

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/home_data_source/remote/home_remote_data_source.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failer, bool>> verifyRoomPassword(
    String roomID,
    String password,
  ) async {
    try {
      final isValid = await _homeRemoteDataSource.verifyRoomPassword(
        roomID,
        password,
      );
      return Right(isValid);
    } catch (error) {
      return Left(Failer(_cleanError(error)));
    }
  }

  @override
  Stream<List<RoomModel>> getMyRooms() {
    return _homeRemoteDataSource.getMyRooms();
  }

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async {
    try {
      await _homeRemoteDataSource.deleteRoom(roomID);
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

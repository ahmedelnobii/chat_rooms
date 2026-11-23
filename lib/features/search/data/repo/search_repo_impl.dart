import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/search/data/data_source/remote/search_remote_data_source.dart';
import 'package:chat_rooms/features/search/data/repo/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource _searchRemoteDataSource;

  SearchRepoImpl(this._searchRemoteDataSource);

  @override
  Future<Either<Failer, List<RoomModel>>> searchRooms(String query) async {
    try {
      final rooms = await _searchRemoteDataSource.searchRooms(query);
      return Right(rooms);
    } catch (error) {
      return Left(
        Failer(
          error
              .toString()
              .replaceFirst('Exception: ', '')
              .replaceFirst('Bad state: ', ''),
        ),
      );
    }
  }
}

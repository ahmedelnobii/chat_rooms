import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/search/data/repo/search_repo.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('searchRooms emits results and clearSearch resets state', () async {
    final rooms = [
      RoomModel(
        creatorId: 'c1',
        creatorName: 'Creator',
        roomID: 'r1',
        roomName: 'Flutter Dev',
        description: 'Flutter discussions',
      ),
    ];
    final repo = _FakeSearchRepo(Right(rooms));
    final cubit = SearchCubit(repo);

    await cubit.searchRooms('  Flutter  ');

    expect(repo.lastQuery, 'Flutter');
    expect(cubit.state.hasSearched, isTrue);
    expect(cubit.state.results, rooms);

    cubit.clearSearch();
    expect(cubit.state.hasSearched, isFalse);
    expect(cubit.state.results, isEmpty);

    await cubit.close();
  });

  test('searchRooms emits error message on failure', () async {
    final repo = _FakeSearchRepo(Left(Failer('Network error')));
    final cubit = SearchCubit(repo);

    await cubit.searchRooms('Flutter');

    expect(cubit.state.hasSearched, isTrue);
    expect(cubit.state.error, 'Network error');
    await cubit.close();
  });
}

class _FakeSearchRepo implements SearchRepo {
  final Either<Failer, List<RoomModel>> result;
  String? lastQuery;

  _FakeSearchRepo(this.result);

  @override
  Future<Either<Failer, List<RoomModel>>> searchRooms(String query) async {
    lastQuery = query;
    return result;
  }
}

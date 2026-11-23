import 'package:chat_rooms/features/search/data/repo/search_repo.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _searchRepo;

  SearchCubit(this._searchRepo) : super(const SearchState());

  Future<void> searchRooms(String rawQuery) async {
    final trimmedQuery = rawQuery.trim();
    if (trimmedQuery.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(
      state.copyWith(
        query: trimmedQuery,
        isLoading: true,
        hasSearched: true,
        clearError: true,
      ),
    );

    final result = await _searchRepo.searchRooms(trimmedQuery);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
      (rooms) => emit(
        state.copyWith(
          results: rooms,
          isLoading: false,
          clearError: true,
        ),
      ),
    );
  }

  void clearSearch() {
    if (isClosed) return;
    emit(const SearchState());
  }
}

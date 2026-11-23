import 'package:chat_rooms/core/models/room_model.dart';

class SearchState {
  final String query;
  final List<RoomModel> results;
  final bool isLoading;
  final bool hasSearched;
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<RoomModel>? results,
    bool? isLoading,
    bool? hasSearched,
    String? error,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      error: clearError ? null : error ?? this.error,
    );
  }
}

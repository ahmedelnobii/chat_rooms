import 'package:chat_rooms/core/models/room_model.dart';

class LikedState {
  final List<RoomModel> rooms;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const LikedState({
    this.rooms = const [],
    this.isLoading = true,
    this.isUpdating = false,
    this.error,
  });

  bool containsRoom(String roomID) {
    return rooms.any((room) => room.roomID == roomID);
  }

  LikedState copyWith({
    List<RoomModel>? rooms,
    bool? isLoading,
    bool? isUpdating,
    String? error,
    bool clearError = false,
  }) {
    return LikedState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : error ?? this.error,
    );
  }
}

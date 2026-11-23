import 'dart:async';

import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LikedCubit extends Cubit<LikedState> {
  final LikedRepo _likedRepo;
  StreamSubscription<List<RoomModel>>? _likedRoomsSubscription;

  LikedCubit(this._likedRepo) : super(const LikedState());

  Future<void> loadLikedRooms() async {
    await _likedRoomsSubscription?.cancel();
    if (isClosed) return;

    emit(state.copyWith(isLoading: true, clearError: true));
    _likedRoomsSubscription = _likedRepo.getLikedRooms().listen(
      (rooms) {
        if (!isClosed) {
          emit(
            state.copyWith(rooms: rooms, isLoading: false, clearError: true),
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, error: _errorMessage(error)));
        }
      },
    );
  }

  Future<void> toggleLike(RoomModel room) async {
    if (state.isLoading || state.isUpdating) return;

    final roomID = room.roomID;
    if (roomID == null || roomID.isEmpty) {
      emit(
        state.copyWith(
          error: 'This room cannot be liked because it has no ID.',
        ),
      );
      return;
    }

    final shouldUnlike = state.containsRoom(roomID);
    emit(state.copyWith(isUpdating: true, clearError: true));

    final result = shouldUnlike
        ? await _likedRepo.removeLikedRoom(roomID)
        : await _likedRepo.addLikedRoom(room);

    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isUpdating: false, error: failure.message)),
      (_) => emit(state.copyWith(isUpdating: false)),
    );
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Future<void> close() async {
    await _likedRoomsSubscription?.cancel();
    return super.close();
  }
}

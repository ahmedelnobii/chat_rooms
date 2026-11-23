import 'dart:async';

import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  StreamSubscription<List<RoomModel>>? _allRoomsSubscription;
  StreamSubscription<List<RoomModel>>? _myRoomsSubscription;
  bool _isLoadingRooms = false;
  bool _isClosing = false;

  HomeCubit(this._homeRepo) : super(const HomeState());

  Future<void> loadRooms() async {
    if (_isLoadingRooms || _isClosing || isClosed) return;
    _isLoadingRooms = true;

    try {
      if (_allRoomsSubscription != null || _myRoomsSubscription != null) {
        await _cancelSubscriptions();
      }
      if (_isClosing || isClosed) return;

      emit(const HomeState());

      try {
        _allRoomsSubscription = _homeRepo.getAllRooms().listen(
          (rooms) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  allRooms: rooms,
                  isLoadingAllRooms: false,
                  clearAllRoomsError: true,
                ),
              );
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  isLoadingAllRooms: false,
                  allRoomsError: error.toString(),
                ),
              );
            }
          },
          onDone: () {
            if (!isClosed) {
              emit(state.copyWith(isLoadingAllRooms: false));
            }
          },
        );
      } catch (error) {
        emit(
          state.copyWith(
            isLoadingAllRooms: false,
            allRoomsError: error.toString(),
          ),
        );
      }

      try {
        _myRoomsSubscription = _homeRepo.getMyRooms().listen(
          (rooms) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  myRooms: rooms,
                  isLoadingMyRooms: false,
                  clearMyRoomsError: true,
                ),
              );
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  isLoadingMyRooms: false,
                  myRoomsError: error.toString(),
                ),
              );
            }
          },
          onDone: () {
            if (!isClosed) {
              emit(state.copyWith(isLoadingMyRooms: false));
            }
          },
        );
      } catch (error) {
        emit(
          state.copyWith(
            isLoadingMyRooms: false,
            myRoomsError: error.toString(),
          ),
        );
      }
    } finally {
      _isLoadingRooms = false;
    }
  }

  Future<void> _cancelSubscriptions() async {
    final allRoomsSubscription = _allRoomsSubscription;
    final myRoomsSubscription = _myRoomsSubscription;
    _allRoomsSubscription = null;
    _myRoomsSubscription = null;

    await Future.wait([
      if (allRoomsSubscription != null) allRoomsSubscription.cancel(),
      if (myRoomsSubscription != null) myRoomsSubscription.cancel(),
    ]);
  }

  Future<bool> deleteRoom(String roomID) async {
    if (state.isDeletingRoom || _isClosing || isClosed) return false;
    emit(state.copyWith(isDeletingRoom: true, clearDeleteRoomError: true));

    final result = await _homeRepo.deleteRoom(roomID);
    return result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isDeletingRoom: false,
              deleteRoomError: failure.message,
            ),
          );
        }
        return false;
      },
      (_) {
        if (!isClosed) {
          emit(
            state.copyWith(isDeletingRoom: false, clearDeleteRoomError: true),
          );
        }
        return true;
      },
    );
  }

  @override
  Future<void> close() async {
    _isClosing = true;
    await _cancelSubscriptions();
    return super.close();
  }
}

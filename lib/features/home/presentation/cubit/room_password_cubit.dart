import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoomPasswordCubit extends Cubit<RoomPasswordState> {
  final HomeRepo _homeRepo;

  RoomPasswordCubit(this._homeRepo) : super(const RoomPasswordInitial());

  Future<void> verifyRoomPassword(String roomID, String password) async {
    if (state is RoomPasswordLoading) return;

    if (password.trim().isEmpty) {
      emit(
        const RoomPasswordInitial(message: 'Please enter the room password.'),
      );
      return;
    }

    emit(const RoomPasswordLoading());

    final result = await _homeRepo.verifyRoomPassword(roomID, password);
    if (isClosed) return;

    result.fold(
      (failure) => emit(RoomPasswordInitial(message: failure.message)),
      (isValid) {
        if (isValid) {
          emit(const RoomPasswordSuccess());
        } else {
          emit(const RoomPasswordInitial(message: 'Incorrect room password.'));
        }
      },
    );
  }
}

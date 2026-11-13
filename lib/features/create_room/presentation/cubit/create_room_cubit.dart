import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/create_room/data/repo/create_room_repo.dart';
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateRoomCubit extends Cubit<CreateRoomStates> {
  final CreateRoomRepo _createRoomRepo;
  CreateRoomCubit(this._createRoomRepo) : super(CreateRoomInit());

  Future<void> createRoom(RoomModel room) async {
    emit(CreateRoomLoading());
    final res = await _createRoomRepo.createRoom(room);
    res.fold(
      (l) => emit(CreateRoomError(l.message)),
      (r) => emit(CreateRoomSuccess()),
    );
  }
}

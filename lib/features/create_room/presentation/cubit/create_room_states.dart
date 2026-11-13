abstract class CreateRoomStates {}

class CreateRoomInit extends CreateRoomStates {}

class CreateRoomLoading extends CreateRoomStates {}

class CreateRoomSuccess extends CreateRoomStates {}

class CreateRoomError extends CreateRoomStates {
  String msg;
  CreateRoomError(this.msg);
}

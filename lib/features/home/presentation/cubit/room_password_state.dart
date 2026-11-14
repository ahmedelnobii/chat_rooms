sealed class RoomPasswordState {
  const RoomPasswordState();
}

final class RoomPasswordInitial extends RoomPasswordState {
  final String? message;

  const RoomPasswordInitial({this.message});
}

final class RoomPasswordLoading extends RoomPasswordState {
  const RoomPasswordLoading();
}

final class RoomPasswordSuccess extends RoomPasswordState {
  const RoomPasswordSuccess();
}

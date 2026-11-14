import 'package:chat_rooms/core/models/room_model.dart';

class HomeState {
  final List<RoomModel> allRooms;
  final List<RoomModel> myRooms;
  final bool isLoadingAllRooms;
  final bool isLoadingMyRooms;
  final String? allRoomsError;
  final String? myRoomsError;

  const HomeState({
    this.allRooms = const [],
    this.myRooms = const [],
    this.isLoadingAllRooms = true,
    this.isLoadingMyRooms = true,
    this.allRoomsError,
    this.myRoomsError,
  });

  HomeState copyWith({
    List<RoomModel>? allRooms,
    List<RoomModel>? myRooms,
    bool? isLoadingAllRooms,
    bool? isLoadingMyRooms,
    String? allRoomsError,
    String? myRoomsError,
    bool clearAllRoomsError = false,
    bool clearMyRoomsError = false,
  }) {
    return HomeState(
      allRooms: allRooms ?? this.allRooms,
      myRooms: myRooms ?? this.myRooms,
      isLoadingAllRooms: isLoadingAllRooms ?? this.isLoadingAllRooms,
      isLoadingMyRooms: isLoadingMyRooms ?? this.isLoadingMyRooms,
      allRoomsError: clearAllRoomsError
          ? null
          : allRoomsError ?? this.allRoomsError,
      myRoomsError: clearMyRoomsError
          ? null
          : myRoomsError ?? this.myRoomsError,
    );
  }
}

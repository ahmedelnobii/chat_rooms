import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:firebase_core/firebase_core.dart';

class RoomModel {
  String roomName;
  String roomID;
  String creatorId;
  String creatorName;
  RoomModel({
    required this.creatorId,
    required this.creatorName,
    required this.roomID,
    required this.roomName,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    creatorId: json[FirebaseKeys.roomCreatorIDField],
    creatorName: json[FirebaseKeys.roomCreatorNameField],
    roomID: json[FirebaseKeys.roomIDField],
    roomName: json[FirebaseKeys.roomNameField],
  );

  Map<String, dynamic> toJson() => {
    FirebaseKeys.roomNameField: roomName,
    FirebaseKeys.roomCreatorNameField: creatorName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.roomCreatorIDField: creatorId,
  };
}

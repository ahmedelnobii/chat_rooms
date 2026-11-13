import 'package:chat_rooms/core/consts/firebase_keys.dart';

class RoomModel {
  String roomName;
  String? roomID;
  String creatorId;
  String creatorName;
  String description;

  RoomModel({
    required this.creatorId,
    required this.creatorName,
    this.roomID,
    required this.roomName,
    required this.description,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    creatorId: json[FirebaseKeys.roomCreatorIDField] ?? '',
    creatorName: json[FirebaseKeys.roomCreatorNameField] ?? '',
    roomID: json[FirebaseKeys.roomIDField] ?? '',
    roomName: json[FirebaseKeys.roomNameField] ?? '',
    description: json[FirebaseKeys.roomDescriptionField] ?? '',
  );

  Map<String, dynamic> toJson() => {
    FirebaseKeys.roomNameField: roomName,
    FirebaseKeys.roomDescriptionField: description,
    FirebaseKeys.roomCreatorNameField: creatorName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.roomCreatorIDField: creatorId,
  };
}

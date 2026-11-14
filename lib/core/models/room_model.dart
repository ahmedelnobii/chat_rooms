import 'package:chat_rooms/core/consts/firebase_keys.dart';

class RoomModel {
  String roomName;
  String? roomID;
  String creatorId;
  String creatorName;
  String description;
  bool isPrivate;
  String? password;

  RoomModel({
    required this.creatorId,
    required this.creatorName,
    this.roomID,
    required this.roomName,
    required this.description,
    this.isPrivate = false,
    this.password,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    creatorId: json[FirebaseKeys.roomCreatorIDField] ?? '',
    creatorName: json[FirebaseKeys.roomCreatorNameField] ?? '',
    roomID: json[FirebaseKeys.roomIDField] ?? '',
    roomName: json[FirebaseKeys.roomNameField] ?? '',
    description: json[FirebaseKeys.roomDescriptionField] ?? '',
    isPrivate: json[FirebaseKeys.roomIsPrivateField] ?? false,
  );

  Map<String, dynamic> toJson() => {
    FirebaseKeys.roomNameField: roomName,
    FirebaseKeys.roomDescriptionField: description,
    FirebaseKeys.roomCreatorNameField: creatorName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.roomCreatorIDField: creatorId,
    FirebaseKeys.roomIsPrivateField: isPrivate,
  };
}

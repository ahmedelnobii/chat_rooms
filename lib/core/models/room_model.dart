import 'package:chat_rooms/core/consts/firebase_keys.dart';

class RoomMemberModel {
  final String userID;
  final String name;

  const RoomMemberModel({required this.userID, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomMemberModel &&
          runtimeType == other.runtimeType &&
          userID == other.userID &&
          name == other.name;

  @override
  int get hashCode => Object.hash(userID, name);
}

class RoomModel {
  String roomName;
  String? roomID;
  String creatorId;
  String creatorName;
  String description;
  bool isPrivate;
  String? password;
  List<RoomMemberModel> members;

  RoomModel({
    required this.creatorId,
    required this.creatorName,
    this.roomID,
    required this.roomName,
    required this.description,
    this.isPrivate = false,
    this.password,
    this.members = const [],
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final rawMembers = json[FirebaseKeys.roomMembersField];
    final parsedMembers = <RoomMemberModel>[];
    if (rawMembers is Map) {
      rawMembers.forEach((key, value) {
        final uid = key?.toString().trim() ?? '';
        final memberName = value?.toString().trim() ?? '';
        if (uid.isNotEmpty) {
          parsedMembers.add(
            RoomMemberModel(
              userID: uid,
              name: memberName.isEmpty ? 'User' : memberName,
            ),
          );
        }
      });
    }

    return RoomModel(
      creatorId: json[FirebaseKeys.roomCreatorIDField] ?? '',
      creatorName: json[FirebaseKeys.roomCreatorNameField] ?? '',
      roomID: json[FirebaseKeys.roomIDField] ?? '',
      roomName: json[FirebaseKeys.roomNameField] ?? '',
      description: json[FirebaseKeys.roomDescriptionField] ?? '',
      isPrivate: json[FirebaseKeys.roomIsPrivateField] ?? false,
      members: List.unmodifiable(parsedMembers),
    );
  }

  Map<String, dynamic> toJson() => {
    FirebaseKeys.roomNameField: roomName,
    FirebaseKeys.roomDescriptionField: description,
    FirebaseKeys.roomCreatorNameField: creatorName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.roomCreatorIDField: creatorId,
    FirebaseKeys.roomIsPrivateField: isPrivate,
  };
}

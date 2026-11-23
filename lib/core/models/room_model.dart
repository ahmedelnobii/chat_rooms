import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int membersCount;
  DateTime createdAt;

  RoomModel({
    required this.creatorId,
    required this.creatorName,
    this.roomID,
    required this.roomName,
    required this.description,
    this.isPrivate = false,
    this.password,
    this.members = const [],
    int? membersCount,
    DateTime? createdAt,
  }) : membersCount = membersCount ?? members.length,
       createdAt =
           createdAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

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

    final rawCount = json[FirebaseKeys.roomMembersCountField];
    final count = rawCount is num ? rawCount.toInt() : parsedMembers.length;

    return RoomModel(
      creatorId: json[FirebaseKeys.roomCreatorIDField] ?? '',
      creatorName: json[FirebaseKeys.roomCreatorNameField] ?? '',
      roomID: json[FirebaseKeys.roomIDField] ?? '',
      roomName: json[FirebaseKeys.roomNameField] ?? '',
      description: json[FirebaseKeys.roomDescriptionField] ?? '',
      isPrivate: json[FirebaseKeys.roomIsPrivateField] ?? false,
      password: json[FirebaseKeys.roomPasswordField] as String?,
      members: List.unmodifiable(parsedMembers),
      membersCount: parsedMembers.isNotEmpty ? parsedMembers.length : count,
      createdAt: _parseCreatedAt(json[FirebaseKeys.roomCreatedAtField]),
    );
  }

  static DateTime _parseCreatedAt(Object? raw) {
    if (raw is Timestamp) {
      return raw.toDate().toUtc();
    }
    if (raw is DateTime) {
      return raw.toUtc();
    }
    if (raw is String && raw.isNotEmpty) {
      return DateTime.tryParse(raw)?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  Map<String, dynamic> toJson() => {
    FirebaseKeys.roomNameField: roomName,
    FirebaseKeys.roomDescriptionField: description,
    FirebaseKeys.roomCreatorNameField: creatorName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.roomCreatorIDField: creatorId,
    FirebaseKeys.roomIsPrivateField: isPrivate,
    if (isPrivate && password != null)
      FirebaseKeys.roomPasswordField: password,
    FirebaseKeys.roomMembersCountField: membersCount,
    FirebaseKeys.roomCreatedAtField: createdAt.toUtc().toIso8601String(),
  };
}

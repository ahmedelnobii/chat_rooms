import 'package:chat_rooms/core/consts/firebase_keys.dart';

class MessageModel {
  String content;
  String senderName;
  String roomID;
  String? messageID;
  String senderID;
  DateTime createdAt;
  bool isPending;

  MessageModel({
    required this.content,
    required this.senderName,
    required this.roomID,
    this.messageID,
    required this.senderID,
    required this.createdAt,
    this.isPending = false,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    bool isPending = false,
  }) => MessageModel(
    content: json[FirebaseKeys.messageTextField] as String,
    senderName: json[FirebaseKeys.messageSenderNameField] as String,
    roomID: json[FirebaseKeys.roomIDField] as String,
    messageID: json[FirebaseKeys.messageIDField] as String?,
    senderID: json[FirebaseKeys.messageSenderIDField] as String,
    isPending: isPending,
    createdAt: DateTime.parse(
      json[FirebaseKeys.messageTimestampField] as String,
    ),
  );

  Map<String, dynamic> toJson() => {
    FirebaseKeys.messageTextField: content,
    FirebaseKeys.messageSenderNameField: senderName,
    FirebaseKeys.roomIDField: roomID,
    FirebaseKeys.messageIDField: messageID,
    FirebaseKeys.messageSenderIDField: senderID,
    FirebaseKeys.messageTimestampField: createdAt.toUtc().toIso8601String(),
  };
}

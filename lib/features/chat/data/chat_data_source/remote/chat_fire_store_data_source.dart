import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_remote_data_source.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ChatRemoteDataSource)
class ChatFireStoreDataSource implements ChatRemoteDataSource {
  final fireStore = FirebaseFirestore.instance;
  @override
  Stream<List<MessageModel>> getMessages(String roomID) {
    final messageRef = fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID)
        .collection(FirebaseKeys.roomChatSubCollection)
        .orderBy(FirebaseKeys.messageTimestampField);

    final List<MessageModel> messages = [];
    return messageRef.snapshots().map((snapshots) {
      for (final change in snapshots.docChanges) {
        if (change.type == .added) {
          messages.add(MessageModel.fromJson(change.doc.data() ?? {}));
        }
      }
      return messages;
    });
  }

  @override
  Future<void> sendMessage(MessageModel msg) async {
    try {
      final docMsgRef = fireStore
          .collection(FirebaseKeys.allRoomsCollection)
          .doc(msg.roomID)
          .collection(FirebaseKeys.roomChatSubCollection)
          .doc();
      msg.messageID = docMsgRef.id;
      await docMsgRef.set(msg.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}

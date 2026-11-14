import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_remote_data_source.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ChatRemoteDataSource)
class ChatFireStoreDataSource implements ChatRemoteDataSource {
  final fireStore = FirebaseFirestore.instance;

  @override
  Future<RoomModel> getRoom(String roomID) async {
    final snapshot = await fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID)
        .get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw StateError('Room "$roomID" was not found.');
    }

    return RoomModel.fromJson({...data, FirebaseKeys.roomIDField: snapshot.id});
  }

  @override
  Stream<List<MessageModel>> getMessages(String roomID) {
    final messageRef = fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID)
        .collection(FirebaseKeys.roomChatSubCollection)
        .orderBy(FirebaseKeys.messageTimestampField);

    return messageRef.snapshots(includeMetadataChanges: true).map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => MessageModel.fromJson(
              doc.data(),
              isPending: doc.metadata.hasPendingWrites,
            ),
          )
          .toList();
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

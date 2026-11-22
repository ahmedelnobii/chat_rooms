import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_remote_data_source.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Stream<RoomModel> watchRoom(String roomID) {
    return fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (!snapshot.exists || data == null) {
            throw StateError('Room "$roomID" was not found.');
          }
          return RoomModel.fromJson({
            ...data,
            FirebaseKeys.roomIDField: snapshot.id,
          });
        });
  }

  @override
  Future<void> joinRoomPresence({
    required String roomID,
    required String userID,
    required String userName,
  }) async {
    if (roomID.isEmpty || userID.isEmpty) return;
    final cleanName = userName.trim().isEmpty ? 'User' : userName.trim();
    final roomRef = fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID);
    try {
      await fireStore.runTransaction((transaction) async {
        final snapshot = await transaction.get(roomRef);
        final data = snapshot.data();
        if (!snapshot.exists || data == null) return;

        final rawMembers = data[FirebaseKeys.roomMembersField];
        final members = rawMembers is Map
            ? Map<String, dynamic>.from(rawMembers)
            : <String, dynamic>{};
        members[userID] = cleanName;

        transaction.update(roomRef, {
          '${FirebaseKeys.roomMembersField}.$userID': cleanName,
          FirebaseKeys.roomMembersCountField: members.length,
        });
      });
    } on FirebaseException {
      // Ignore if room is being deleted or user has no permission yet
    }
  }

  @override
  Future<void> leaveRoomPresence({
    required String roomID,
    required String userID,
  }) async {
    if (roomID.isEmpty || userID.isEmpty) return;
    final roomRef = fireStore
        .collection(FirebaseKeys.allRoomsCollection)
        .doc(roomID);
    try {
      await fireStore.runTransaction((transaction) async {
        final snapshot = await transaction.get(roomRef);
        final data = snapshot.data();
        if (!snapshot.exists || data == null) return;

        final rawMembers = data[FirebaseKeys.roomMembersField];
        final members = rawMembers is Map
            ? Map<String, dynamic>.from(rawMembers)
            : <String, dynamic>{};
        members.remove(userID);

        transaction.update(roomRef, {
          '${FirebaseKeys.roomMembersField}.$userID': FieldValue.delete(),
          FirebaseKeys.roomMembersCountField: members.length,
        });
      });
    } on FirebaseException {
      // Ignore if room was already deleted
    }
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

  @override
  Future<void> deleteRoom(String roomID) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw StateError('Sign in to delete a room.');
    }

    try {
      final roomRef = fireStore
          .collection(FirebaseKeys.allRoomsCollection)
          .doc(roomID);
      final roomSnapshot = await roomRef.get();
      final roomData = roomSnapshot.data();

      if (!roomSnapshot.exists || roomData == null) {
        throw StateError('Room "$roomID" was not found.');
      }

      if (roomData[FirebaseKeys.roomCreatorIDField] != currentUserId) {
        throw StateError('Only the room creator can delete this room.');
      }

      // 1. Delete all messages in roomChat subcollection
      final messagesSnapshot = await roomRef
          .collection(FirebaseKeys.roomChatSubCollection)
          .get();
      if (messagesSnapshot.docs.isNotEmpty) {
        final batch = fireStore.batch();
        for (final doc in messagesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      // 2. Remove from current user's liked rooms
      await fireStore
          .collection(FirebaseKeys.usersCollection)
          .doc(currentUserId)
          .collection(FirebaseKeys.userLikesSubCollection)
          .doc(roomID)
          .delete();

      // Also attempt to clean up from any other users' userLikes if permitted/indexed
      try {
        final likedDocs = await fireStore
            .collectionGroup(FirebaseKeys.userLikesSubCollection)
            .where(FirebaseKeys.roomIDField, isEqualTo: roomID)
            .get();
        if (likedDocs.docs.isNotEmpty) {
          final likeBatch = fireStore.batch();
          for (final doc in likedDocs.docs) {
            likeBatch.delete(doc.reference);
          }
          await likeBatch.commit();
        }
      } catch (_) {
        // Ignore if collectionGroup index or cross-user rule is not active
      }

      // 3. Delete the room document itself
      await roomRef.delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }
}

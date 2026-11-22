import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/home_data_source/remote/home_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: HomeRemoteDataSource)
class HomeFirestoreDataSource implements HomeRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<List<RoomModel>> getAllRooms() {
    return _roomsFrom(
      firestore.collection(FirebaseKeys.allRoomsCollection),
      sortByOnlineMembers: true,
    );
  }

  @override
  Stream<List<RoomModel>> getMyRooms() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.error(StateError('Sign in to view the rooms you created.'));
    }

    return _roomsFrom(
      firestore
          .collection(FirebaseKeys.allRoomsCollection)
          .where(FirebaseKeys.roomCreatorIDField, isEqualTo: userId),
    );
  }

  @override
  Future<bool> verifyRoomPassword(String roomID, String password) async {
    try {
      final room = await firestore
          .collection(FirebaseKeys.allRoomsCollection)
          .doc(roomID)
          .get();
      final roomData = room.data();

      return roomData != null &&
          roomData[FirebaseKeys.roomIsPrivateField] == true &&
          roomData['password'] == password;
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  @override
  Future<void> deleteRoom(String roomID) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw StateError('Sign in to delete a room.');
    }

    try {
      final roomRef = firestore
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
        final batch = firestore.batch();
        for (final doc in messagesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      // 2. Remove from current user's liked rooms
      await firestore
          .collection(FirebaseKeys.usersCollection)
          .doc(currentUserId)
          .collection(FirebaseKeys.userLikesSubCollection)
          .doc(roomID)
          .delete();

      // Also attempt to clean up from any other users' userLikes if permitted/indexed
      try {
        final likedDocs = await firestore
            .collectionGroup(FirebaseKeys.userLikesSubCollection)
            .where(FirebaseKeys.roomIDField, isEqualTo: roomID)
            .get();
        if (likedDocs.docs.isNotEmpty) {
          final likeBatch = firestore.batch();
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

  Stream<List<RoomModel>> _roomsFrom(
    Query<Map<String, dynamic>> query, {
    bool sortByOnlineMembers = false,
  }) {
    return query.snapshots().map((snapshot) {
      final rooms = snapshot.docs
          .map(
            (document) => RoomModel.fromJson({
              ...document.data(),
              FirebaseKeys.roomIDField: document.id,
            }),
          )
          .toList();

      if (sortByOnlineMembers) {
        rooms.sort((a, b) {
          final byMembers = b.members.length.compareTo(a.members.length);
          if (byMembers != 0) return byMembers;
          return b.createdAt.compareTo(a.createdAt);
        });
      }

      return List.unmodifiable(rooms);
    });
  }
}

import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/liked/data/liked_data_source/remote/liked_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: LikedRemoteDataSource)
class LikedFirestoreDataSource implements LikedRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userLikesCollection() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw StateError('Sign in to manage liked rooms.');
    }

    return firestore
        .collection(FirebaseKeys.usersCollection)
        .doc(userID)
        .collection(FirebaseKeys.userLikesSubCollection);
  }

  @override
  Stream<List<RoomModel>> getLikedRooms() {
    try {
      return _userLikesCollection().snapshots().asyncMap((snapshot) async {
        final validRooms = <RoomModel>[];
        for (final document in snapshot.docs) {
          final roomID = document.id;
          final roomSnapshot = await firestore
              .collection(FirebaseKeys.allRoomsCollection)
              .doc(roomID)
              .get();

          if (!roomSnapshot.exists) {
            // Room was deleted by its creator; clean up stale like
            try {
              await document.reference.delete();
            } catch (_) {}
            continue;
          }

          validRooms.add(RoomModel.fromJson(document.data()));
        }
        return List.unmodifiable(validRooms);
      });
    } catch (error) {
      return Stream.error(error);
    }
  }

  @override
  Future<void> addLikedRoom(RoomModel room) async {
    final roomID = room.roomID;
    if (roomID == null || roomID.isEmpty) {
      throw ArgumentError.value(roomID, 'room.roomID', 'Must not be empty.');
    }

    try {
      await _userLikesCollection().doc(roomID).set(room.toJson());
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? error.code);
    }
  }

  @override
  Future<void> removeLikedRoom(String roomID) async {
    try {
      await _userLikesCollection().doc(roomID).delete();
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? error.code);
    }
  }
}

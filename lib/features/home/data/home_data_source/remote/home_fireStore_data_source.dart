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
    return _roomsFrom(firestore.collection(FirebaseKeys.allRoomsCollection));
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

  Stream<List<RoomModel>> _roomsFrom(Query<Map<String, dynamic>> query) {
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (document) => RoomModel.fromJson({
              ...document.data(),
              FirebaseKeys.roomIDField: document.id,
            }),
          )
          .toList(growable: false),
    );
  }
}

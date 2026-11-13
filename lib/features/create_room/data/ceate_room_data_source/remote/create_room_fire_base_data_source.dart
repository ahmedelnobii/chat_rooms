import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/create_room/data/ceate_room_data_source/remote/create_room_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: CreateRoomRemoteDataSource)
class CreateRoomFireBaseDataSource implements CreateRoomRemoteDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Future<void> createRoom(RoomModel room) async {
    try {
      final doc = fireStore.collection(FirebaseKeys.allRoomsCollection).doc();
      room.roomID = doc.id;
      doc.set(room.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}

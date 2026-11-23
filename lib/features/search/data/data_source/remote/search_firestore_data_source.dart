import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/search/data/data_source/remote/search_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: SearchRemoteDataSource)
class SearchFirestoreDataSource implements SearchRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<RoomModel>> searchRooms(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const [];
    }

    try {
      final snapshot = await firestore
          .collection(FirebaseKeys.allRoomsCollection)
          .where(
            FirebaseKeys.roomNameField,
            isGreaterThanOrEqualTo: trimmedQuery,
          )
          .where(
            FirebaseKeys.roomNameField,
            isLessThanOrEqualTo: '$trimmedQuery\uf8ff',
          )
          .get();

      final matchedRooms = snapshot.docs
          .map((doc) => RoomModel.fromJson(doc.data()))
          .toList();

      matchedRooms.sort((a, b) {
        final byMembers = b.members.length.compareTo(a.members.length);
        if (byMembers != 0) return byMembers;
        return b.createdAt.compareTo(a.createdAt);
      });

      return List.unmodifiable(matchedRooms);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }
}

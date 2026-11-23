import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProfileRemoteDataSource)
class ProfileFirestoreDataSource implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getProfile() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      return null;
    }

    final userDocument = await firestore
        .collection(FirebaseKeys.usersCollection)
        .doc(userID)
        .get();
    final userData = userDocument.data();
    if (!userDocument.exists || userData == null) {
      throw StateError('Profile document not found for the signed-in user.');
    }

    return UserModel.fromJson(userData);
  }
}

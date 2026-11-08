import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/features/auth/data/data_source/remote/remote_auth_data_source.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: RemoteAuthDataSource)
class FireBaseAuthDataSource implements RemoteAuthDataSource {
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn.instance;

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc = await FirebaseFirestore.instance
          .collection(FirebaseKeys.usersCollection)
          .doc(userCredential.user!.uid)
          .get();
      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
        name: name,
        email: email,
        userID: user.user!.uid,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseKeys.usersCollection)
          .doc(user.user!.uid)
          .set(userModel.toJson());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> continueWithGoogle() async {
    try {
      final googleSignInAccount = await googleSignIn.authenticate();
      final googleAuth = googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      bool isNew = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNew) {
        UserModel userModel = UserModel(
          name: userCredential.user!.displayName ?? "user",
          email: userCredential.user!.email!,
          userID: userCredential.user!.uid,
        );
        await FirebaseFirestore.instance
            .collection(FirebaseKeys.usersCollection)
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());
        return userModel;
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection(FirebaseKeys.usersCollection)
            .doc(userCredential.user!.uid)
            .get();
        return UserModel.fromJson(userDoc.data()!);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

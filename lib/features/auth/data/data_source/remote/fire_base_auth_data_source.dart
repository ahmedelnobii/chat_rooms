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
      GoogleSignIn.instance.initialize();
      final googleSignIn = GoogleSignIn.instance;
      final googleSignInAccount = await googleSignIn.authenticate();
      final googleAuth = googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;
      final userDocRef = FirebaseFirestore.instance
          .collection(FirebaseKeys.usersCollection)
          .doc(user.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists || userDoc.data() == null) {
        UserModel userModel = UserModel(
          name: (user.displayName != null && user.displayName!.isNotEmpty)
              ? user.displayName!
              : "User",
          email: user.email ?? "",
          userID: user.uid,
        );
        await userDocRef.set(userModel.toJson());
        return userModel;
      } else {
        return UserModel.fromJson(userDoc.data()!);
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception("Sign in was cancelled");
      }
      throw Exception(e.description ?? "Google sign in failed");
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Authentication failed");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'package:chat_rooms/core/consts/firebase_keys.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/update_profile/data/data_source/remote/update_profile_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: UpdateProfileRemoteDataSource)
class UpdateProfileFirebaseDataSource implements UpdateProfileRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  bool isGoogleUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return false;
    return user.providerData.any((info) => info.providerId == 'google.com');
  }

  @override
  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Please sign in again.');
    }

    final currentEmail = user.email?.trim().toLowerCase();
    if (currentEmail != null &&
        currentEmail.isNotEmpty &&
        currentEmail != email.trim().toLowerCase()) {
      throw StateError('The email entered does not match your account.');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapAuthError(e));
    }
  }

  @override
  Future<void> reauthenticateWithGoogle() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Please sign in again.');
    }

    try {
      final googleSignInAccount = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw StateError('Google sign in was cancelled.');
      }
      throw StateError(e.description ?? 'Google authentication failed.');
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapAuthError(e));
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? newPassword,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Please sign in again.');
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw StateError('Name cannot be empty.');
    }

    try {
      // 1. Update password if requested (email/password users only)
      if (newPassword != null && newPassword.trim().isNotEmpty) {
        await user.updatePassword(newPassword.trim());
      }

      // 2. Update Firebase Auth displayName
      await user.updateDisplayName(trimmedName);

      // 3. Update user document in Firestore
      final userRef = firestore
          .collection(FirebaseKeys.usersCollection)
          .doc(user.uid);
      await userRef.update({FirebaseKeys.userName: trimmedName});

      // 4. Update senderName in all old messages across all rooms
      await _updateUserNameInOldMessagesAndRooms(user.uid, trimmedName);

      final updatedDoc = await userRef.get();
      final data = updatedDoc.data();
      final email =
          (data?[FirebaseKeys.emailField] as String?) ?? user.email ?? '';

      return UserModel(name: trimmedName, email: email, userID: user.uid);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapAuthError(e));
    } on FirebaseException catch (e) {
      throw StateError(e.message ?? e.code);
    }
  }

  Future<void> _updateUserNameInOldMessagesAndRooms(
    String userID,
    String newName,
  ) async {
    final refsToUpdate =
        <DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>{};

    // Collect rooms created by this user
    final myRoomsSnapshot = await firestore
        .collection(FirebaseKeys.allRoomsCollection)
        .where(FirebaseKeys.roomCreatorIDField, isEqualTo: userID)
        .get();
    for (final roomDoc in myRoomsSnapshot.docs) {
      refsToUpdate[roomDoc.reference] = {
        FirebaseKeys.roomCreatorNameField: newName,
      };
    }

    // Also update the user's name if they are currently listed in any room's active members map
    final allRoomsForMembers = await firestore
        .collection(FirebaseKeys.allRoomsCollection)
        .get();
    for (final roomDoc in allRoomsForMembers.docs) {
      final members = roomDoc.data()[FirebaseKeys.roomMembersField];
      if (members is Map && members.containsKey(userID)) {
        final existing = refsToUpdate[roomDoc.reference] ?? <String, dynamic>{};
        existing['${FirebaseKeys.roomMembersField}.$userID'] = newName;
        refsToUpdate[roomDoc.reference] = existing;
      }
    }

    // Collect all messages sent by this user
    bool updatedViaCollectionGroup = false;
    try {
      final messagesSnapshot = await firestore
          .collectionGroup(FirebaseKeys.roomChatSubCollection)
          .where(FirebaseKeys.messageSenderIDField, isEqualTo: userID)
          .get();
      for (final msgDoc in messagesSnapshot.docs) {
        refsToUpdate[msgDoc.reference] = {
          FirebaseKeys.messageSenderNameField: newName,
        };
      }
      updatedViaCollectionGroup = true;
    } catch (_) {
      // Fallback: iterate through rooms if collectionGroup index is not deployed
    }

    if (!updatedViaCollectionGroup) {
      final allRoomsSnapshot = await firestore
          .collection(FirebaseKeys.allRoomsCollection)
          .get();
      for (final roomDoc in allRoomsSnapshot.docs) {
        try {
          final roomMessagesSnapshot = await roomDoc.reference
              .collection(FirebaseKeys.roomChatSubCollection)
              .where(FirebaseKeys.messageSenderIDField, isEqualTo: userID)
              .get();
          for (final msgDoc in roomMessagesSnapshot.docs) {
            refsToUpdate[msgDoc.reference] = {
              FirebaseKeys.messageSenderNameField: newName,
            };
          }
        } catch (_) {
          // Skip private rooms the user cannot access
        }
      }
    }

    if (refsToUpdate.isEmpty) return;

    // Commit in batches of 450 (Firestore limit is 500 operations per batch)
    final entries = refsToUpdate.entries.toList();
    const batchSize = 450;
    for (var i = 0; i < entries.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < entries.length)
          ? i + batchSize
          : entries.length;
      for (var j = i; j < end; j++) {
        batch.update(entries[j].key, entries[j].value);
      }
      await batch.commit();
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-mismatch':
        return 'The selected account does not match the signed-in user.';
      case 'user-not-found':
        return 'No user found for this account.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'requires-recent-login':
        return 'Session expired. Please sign in again to continue.';
      case 'weak-password':
        return 'The new password is too weak (at least 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

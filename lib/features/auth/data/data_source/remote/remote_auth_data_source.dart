import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class RemoteAuthDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<UserModel> continueWithGoogle();

  /// Returns the currently persisted Firebase session user, or null if none.
  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword(String email);

  /// Removes the current user from any active room members maps and signs out.
  Future<void> signOut();
}

import 'package:chat_rooms/features/auth/data/model/user_model.dart';

abstract class UpdateProfileRemoteDataSource {
  bool isGoogleUser();
  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  });
  Future<void> reauthenticateWithGoogle();
  Future<UserModel> updateProfile({
    required String name,
    String? newPassword,
  });
  Future<void> deleteAccount();
}

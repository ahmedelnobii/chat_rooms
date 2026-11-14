import 'package:chat_rooms/features/auth/data/model/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getProfile();
}

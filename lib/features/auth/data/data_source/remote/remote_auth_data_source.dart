import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:injectable/injectable.dart';
@singleton
abstract class RemoteAuthDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password,String name);
}
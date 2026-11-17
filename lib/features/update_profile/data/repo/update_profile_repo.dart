import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UpdateProfileRepo {
  bool isGoogleUser();
  Future<Either<Failer, void>> reauthenticateWithPassword({
    required String email,
    required String password,
  });
  Future<Either<Failer, void>> reauthenticateWithGoogle();
  Future<Either<Failer, UserModel>> updateProfile({
    required String name,
    String? newPassword,
  });
}

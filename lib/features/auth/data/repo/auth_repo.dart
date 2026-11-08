import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class AuthRepo {
  Future<Either<Failer, UserModel>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failer, void>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<Either<Failer, UserModel>> continueWithGoogle();
}

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/data_source/remote/remote_auth_data_source.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
@Singleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo{
  final RemoteAuthDataSource remoteAuthDataSource;
  AuthRepoImpl({required this.remoteAuthDataSource});
  @override
  Future<Either<Failer,UserModel>> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Call the remote data source to sign in
      final userModel = await remoteAuthDataSource.signInWithEmailAndPassword(email, password);
      return Right(userModel);
    } catch (e) {
      return Left(Failer(e.toString()));
    }
  }

  @override
  Future<Either<Failer,void>> signUpWithEmailAndPassword(String email, String password, String name) async {
   try {
      // Call the remote data source to sign up
      final result = await remoteAuthDataSource.signUpWithEmailAndPassword(email, password, name);
      return Right(Unit);
    } catch (e) {
      return Left(Failer(e.toString()));
    }
  }

}
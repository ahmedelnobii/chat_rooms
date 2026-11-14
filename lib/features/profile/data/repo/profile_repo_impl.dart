import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:chat_rooms/features/profile/data/repo/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _profileRemoteDataSource;

  ProfileRepoImpl(this._profileRemoteDataSource);

  @override
  Future<Either<Failer, UserModel?>> getProfile() async {
    try {
      return Right(await _profileRemoteDataSource.getProfile());
    } on FirebaseException catch (error) {
      return Left(Failer(error.message ?? error.code));
    } on StateError catch (error) {
      return Left(Failer(error.message));
    }
  }
}

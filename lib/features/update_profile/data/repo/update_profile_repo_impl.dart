import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/update_profile/data/data_source/remote/update_profile_remote_data_source.dart';
import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: UpdateProfileRepo)
class UpdateProfileRepoImpl implements UpdateProfileRepo {
  final UpdateProfileRemoteDataSource _remoteDataSource;

  UpdateProfileRepoImpl(this._remoteDataSource);

  @override
  bool isGoogleUser() => _remoteDataSource.isGoogleUser();

  @override
  Future<Either<Failer, void>> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.reauthenticateWithPassword(
        email: email,
        password: password,
      );
      return const Right(null);
    } on StateError catch (error) {
      return Left(Failer(error.message));
    } catch (error) {
      return Left(Failer(error.toString()));
    }
  }

  @override
  Future<Either<Failer, void>> reauthenticateWithGoogle() async {
    try {
      await _remoteDataSource.reauthenticateWithGoogle();
      return const Right(null);
    } on StateError catch (error) {
      return Left(Failer(error.message));
    } catch (error) {
      return Left(Failer(error.toString()));
    }
  }

  @override
  Future<Either<Failer, UserModel>> updateProfile({
    required String name,
    String? newPassword,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        name: name,
        newPassword: newPassword,
      );
      return Right(user);
    } on StateError catch (error) {
      return Left(Failer(error.message));
    } catch (error) {
      return Left(Failer(error.toString()));
    }
  }

  @override
  Future<Either<Failer, void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      return const Right(null);
    } on StateError catch (error) {
      return Left(Failer(error.message));
    } catch (error) {
      return Left(Failer(error.toString()));
    }
  }
}

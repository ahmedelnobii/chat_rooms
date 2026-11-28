import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo.dart';
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reauthenticateWithPassword validates inputs and succeeds when valid', () async {
    final repo = _FakeUpdateProfileRepo();
    final cubit = UpdateProfileCubit(repo);

    await cubit.reauthenticateWithPassword(email: ' ', password: 'secret');
    expect(cubit.state.reauthError, 'Please enter your email.');

    await cubit.reauthenticateWithPassword(
      email: 'ahmed@example.com',
      password: 'secret',
    );
    expect(cubit.state.isReauthenticated, isTrue);
    expect(cubit.state.reauthError, isNull);
    await cubit.close();
  });

  test('updateProfile updates name and deleteAccount marks accountDeleted', () async {
    final repo = _FakeUpdateProfileRepo(googleUser: true);
    final cubit = UpdateProfileCubit(repo);

    await cubit.updateProfile(name: 'New Name', newPassword: 'ignoredPassword');
    expect(repo.lastUpdatedName, 'New Name');
    expect(repo.lastUpdatedPassword, isNull);
    expect(cubit.state.updatedUser?.name, 'New Name');

    await cubit.deleteAccount();
    expect(repo.deleteCalled, isTrue);
    expect(cubit.state.accountDeleted, isTrue);

    await cubit.close();
  });
}

class _FakeUpdateProfileRepo implements UpdateProfileRepo {
  final bool googleUser;
  String? lastUpdatedName;
  String? lastUpdatedPassword;
  bool deleteCalled = false;

  _FakeUpdateProfileRepo({this.googleUser = false});

  @override
  bool isGoogleUser() => googleUser;

  @override
  Future<Either<Failer, void>> reauthenticateWithGoogle() async =>
      const Right(null);

  @override
  Future<Either<Failer, void>> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async => const Right(null);

  @override
  Future<Either<Failer, UserModel>> updateProfile({
    required String name,
    String? newPassword,
  }) async {
    lastUpdatedName = name;
    lastUpdatedPassword = newPassword;
    return Right(
      UserModel(name: name, email: 'user@example.com', userID: 'uid-1'),
    );
  }

  @override
  Future<Either<Failer, void>> deleteAccount() async {
    deleteCalled = true;
    return const Right(null);
  }
}

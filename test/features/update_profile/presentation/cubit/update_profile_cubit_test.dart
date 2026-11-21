import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo.dart';
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reauthenticateWithPassword validates empty fields', () async {
    final repo = _FakeUpdateProfileRepo();
    final cubit = UpdateProfileCubit(repo);

    await cubit.reauthenticateWithPassword(email: '  ', password: 'secret');
    expect(cubit.state.reauthError, 'Please enter your email.');
    expect(cubit.state.isReauthenticated, isFalse);

    await cubit.reauthenticateWithPassword(
      email: 'ahmed@example.com',
      password: '',
    );
    expect(cubit.state.reauthError, 'Please enter your password.');
    expect(cubit.state.isReauthenticated, isFalse);

    await cubit.close();
  });

  test('reauthenticateWithPassword emits success when valid', () async {
    final repo = _FakeUpdateProfileRepo();
    final cubit = UpdateProfileCubit(repo);

    await cubit.reauthenticateWithPassword(
      email: 'ahmed@example.com',
      password: 'secret',
    );

    expect(cubit.state.isReauthenticated, isTrue);
    expect(cubit.state.reauthError, isNull);
    await cubit.close();
  });

  test('reauthenticateWithGoogle emits error on failure', () async {
    final repo = _FakeUpdateProfileRepo(
      googleUser: true,
      reauthResult: Left(Failer('Google sign in was cancelled.')),
    );
    final cubit = UpdateProfileCubit(repo);

    expect(cubit.state.isGoogleUser, isTrue);
    await cubit.reauthenticateWithGoogle();

    expect(cubit.state.isReauthenticated, isFalse);
    expect(cubit.state.reauthError, 'Google sign in was cancelled.');
    await cubit.close();
  });

  test(
    'updateProfile updates name and ignores password for Google users',
    () async {
      final repo = _FakeUpdateProfileRepo(googleUser: true);
      final cubit = UpdateProfileCubit(repo);

      await cubit.updateProfile(
        name: 'New Name',
        newPassword: 'newPassword123',
      );

      expect(repo.lastUpdatedName, 'New Name');
      expect(repo.lastUpdatedPassword, isNull);
      expect(cubit.state.updatedUser?.name, 'New Name');
      await cubit.close();
    },
  );
  test('deleteAccount emits accountDeleted on success', () async {
    final repo = _FakeUpdateProfileRepo();
    final cubit = UpdateProfileCubit(repo);

    await cubit.deleteAccount();

    expect(repo.deleteCalled, isTrue);
    expect(cubit.state.accountDeleted, isTrue);
    expect(cubit.state.isDeleting, isFalse);
    expect(cubit.state.deleteError, isNull);
    await cubit.close();
  });
}

class _FakeUpdateProfileRepo implements UpdateProfileRepo {
  final bool googleUser;
  final Either<Failer, void> reauthResult;
  String? lastUpdatedName;
  String? lastUpdatedPassword;
  bool deleteCalled = false;

  _FakeUpdateProfileRepo({
    this.googleUser = false,
    this.reauthResult = const Right(null),
  });

  @override
  bool isGoogleUser() => googleUser;

  @override
  Future<Either<Failer, void>> reauthenticateWithGoogle() async => reauthResult;

  @override
  Future<Either<Failer, void>> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async => reauthResult;

  @override
  Future<Either<Failer, void>> deleteAccount() async {
    deleteCalled = true;
    return const Right(null);
  }

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
}

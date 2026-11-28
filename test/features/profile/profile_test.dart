import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/data/repo/profile_repo.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads the profile from the repository and updates via setProfile', () async {
    final profile = UserModel(
      name: 'Ahmed',
      email: 'ahmed@example.com',
      userID: 'user-id',
    );
    final repo = _FakeProfileRepo(result: Right(profile));
    final cubit = ProfileCubit(repo);

    await cubit.loadProfile();

    expect(cubit.state.profile?.userID, 'user-id');
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.error, isNull);

    final updated = UserModel(
      name: 'Ahmed Updated',
      email: 'ahmed@example.com',
      userID: 'user-id',
    );
    cubit.setProfile(updated);
    expect(cubit.state.profile?.name, 'Ahmed Updated');

    cubit.clearProfile();
    expect(cubit.state.profile, isNull);

    await cubit.close();
  });

  test('exposes profile loading errors in state', () async {
    final repo = _FakeProfileRepo(result: Left(Failer('Profile unavailable')));
    final cubit = ProfileCubit(repo);

    await cubit.loadProfile();

    expect(cubit.state.profile, isNull);
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.error, 'Profile unavailable');

    await cubit.close();
  });
}

class _FakeProfileRepo implements ProfileRepo {
  final Either<Failer, UserModel?> result;

  _FakeProfileRepo({required this.result});

  @override
  Future<Either<Failer, UserModel?>> getProfile() async => result;
}

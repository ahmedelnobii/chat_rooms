import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:chat_rooms/features/profile/data/repo/profile_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts data source errors into repository failures', () async {
    final repo = ProfileRepoImpl(
      _FailingProfileRemoteDataSource(StateError('Profile unavailable')),
    );

    final result = await repo.getProfile();

    expect(
      result.fold((failure) => failure.message, (_) => null),
      'Profile unavailable',
    );
  });
}

class _FailingProfileRemoteDataSource implements ProfileRemoteDataSource {
  final Object error;

  _FailingProfileRemoteDataSource(this.error);

  @override
  Future<UserModel?> getProfile() async {
    throw error;
  }
}

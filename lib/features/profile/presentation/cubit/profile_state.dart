import 'package:chat_rooms/features/auth/data/model/user_model.dart';

class ProfileState {
  final UserModel? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({this.profile, this.isLoading = true, this.error});

  ProfileState copyWith({
    UserModel? profile,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

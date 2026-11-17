import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/data/repo/profile_repo.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileState());

  void setProfile(UserModel profile) {
    if (isClosed) return;
    emit(state.copyWith(profile: profile, isLoading: false, clearError: true));
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _profileRepo.getProfile();
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (profile) => emit(
        state.copyWith(profile: profile, isLoading: false, clearError: true),
      ),
    );
  }
}

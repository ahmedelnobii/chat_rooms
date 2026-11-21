import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo.dart';
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo _updateProfileRepo;

  UpdateProfileCubit(this._updateProfileRepo)
    : super(UpdateProfileState(isGoogleUser: _updateProfileRepo.isGoogleUser()));

  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    if (state.isReauthenticating) return;

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      emit(state.copyWith(reauthError: 'Please enter your email.'));
      return;
    }
    if (password.isEmpty) {
      emit(state.copyWith(reauthError: 'Please enter your password.'));
      return;
    }

    emit(
      state.copyWith(
        isReauthenticating: true,
        isReauthenticated: false,
        clearReauthError: true,
      ),
    );

    final result = await _updateProfileRepo.reauthenticateWithPassword(
      email: trimmedEmail,
      password: password,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isReauthenticating: false,
          isReauthenticated: false,
          reauthError: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isReauthenticating: false,
          isReauthenticated: true,
          clearReauthError: true,
        ),
      ),
    );
  }

  Future<void> reauthenticateWithGoogle() async {
    if (state.isReauthenticating) return;

    emit(
      state.copyWith(
        isReauthenticating: true,
        isReauthenticated: false,
        clearReauthError: true,
      ),
    );

    final result = await _updateProfileRepo.reauthenticateWithGoogle();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isReauthenticating: false,
          isReauthenticated: false,
          reauthError: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isReauthenticating: false,
          isReauthenticated: true,
          clearReauthError: true,
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    if (state.isDeleting || state.isSaving) return;

    emit(state.copyWith(isDeleting: true, clearDeleteError: true));

    final result = await _updateProfileRepo.deleteAccount();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isDeleting: false, deleteError: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          isDeleting: false,
          accountDeleted: true,
          clearDeleteError: true,
        ),
      ),
    );
  }

  Future<void> updateProfile({
    required String name,
    String? newPassword,
  }) async {
    if (state.isSaving) return;

    final trimmedName = name.trim();
    if (trimmedName.length < 3) {
      emit(
        state.copyWith(saveError: 'Name must be at least 3 characters.'),
      );
      return;
    }

    final cleanPassword =
        (newPassword != null && newPassword.trim().isNotEmpty)
        ? newPassword.trim()
        : null;
    if (cleanPassword != null && cleanPassword.length < 6) {
      emit(
        state.copyWith(
          saveError: 'New password must be at least 6 characters.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        clearSaveError: true,
        clearUpdatedUser: true,
      ),
    );

    final result = await _updateProfileRepo.updateProfile(
      name: trimmedName,
      newPassword: state.isGoogleUser ? null : cleanPassword,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isSaving: false, saveError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSaving: false,
          updatedUser: user,
          clearSaveError: true,
        ),
      ),
    );
  }
}

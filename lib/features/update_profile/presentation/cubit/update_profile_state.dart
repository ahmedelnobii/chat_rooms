import 'package:chat_rooms/features/auth/data/model/user_model.dart';

class UpdateProfileState {
  final bool isGoogleUser;
  final bool isReauthenticating;
  final bool isReauthenticated;
  final String? reauthError;
  final bool isSaving;
  final UserModel? updatedUser;
  final String? saveError;
  final bool isDeleting;
  final bool accountDeleted;
  final String? deleteError;

  const UpdateProfileState({
    this.isGoogleUser = false,
    this.isReauthenticating = false,
    this.isReauthenticated = false,
    this.reauthError,
    this.isSaving = false,
    this.updatedUser,
    this.saveError,
    this.isDeleting = false,
    this.accountDeleted = false,
    this.deleteError,
  });

  UpdateProfileState copyWith({
    bool? isGoogleUser,
    bool? isReauthenticating,
    bool? isReauthenticated,
    String? reauthError,
    bool? isSaving,
    UserModel? updatedUser,
    String? saveError,
    bool? isDeleting,
    bool? accountDeleted,
    String? deleteError,
    bool clearReauthError = false,
    bool clearSaveError = false,
    bool clearUpdatedUser = false,
    bool clearDeleteError = false,
  }) {
    return UpdateProfileState(
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      isReauthenticating: isReauthenticating ?? this.isReauthenticating,
      isReauthenticated: isReauthenticated ?? this.isReauthenticated,
      reauthError: clearReauthError ? null : reauthError ?? this.reauthError,
      isSaving: isSaving ?? this.isSaving,
      updatedUser: clearUpdatedUser ? null : updatedUser ?? this.updatedUser,
      saveError: clearSaveError ? null : saveError ?? this.saveError,
      isDeleting: isDeleting ?? this.isDeleting,
      accountDeleted: accountDeleted ?? this.accountDeleted,
      deleteError: clearDeleteError ? null : deleteError ?? this.deleteError,
    );
  }
}

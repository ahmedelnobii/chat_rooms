import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepository;
  AuthCubit(this.authRepository) : super(AuthInitialState());

  UserModel? cuurentUser;

  UserModel? get currentUser => cuurentUser;
  set currentUser(UserModel? user) => cuurentUser = user;

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    final res = await authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    res.fold((l) => emit(LoginErrorState(l.message)), (user) {
      cuurentUser = user;
      emit(LoginSuccessState(user));
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    final res = await authRepository.signUpWithEmailAndPassword(
      email,
      password,
      name,
    );
    res.fold(
      (l) => emit(RegisterErrorState(l.message)),
      (r) => emit(RegisterSuccessState()),
    );
  }

  Future<void> continueWithGoogle() async {
    emit(GoogleSignInLoadingState());
    final res = await authRepository.continueWithGoogle();
    res.fold((l) => emit(GoogleSignInErrorState(l.message)), (user) {
      cuurentUser = user;
      emit(GoogleSignInSuccessState(user));
    });
  }

  Future<void> signInWithGoogle() => continueWithGoogle();

  /// Checks if a Firebase session is still persisted.
  /// Emits [SessionActiveState] with the user if logged in,
  /// or [SessionExpiredState] if not.
  Future<void> checkSession() async {
    emit(SessionCheckLoadingState());
    final res = await authRepository.getCurrentUser();
    res.fold(
      (l) => emit(SessionExpiredState()),
      (user) {
        if (user != null) {
          cuurentUser = user;
          emit(SessionActiveState(user));
        } else {
          emit(SessionExpiredState());
        }
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    final res = await authRepository.resetPassword(email);
    res.fold(
      (failure) => emit(ResetPasswordErrorState(failure.message)),
      (_) => emit(ResetPasswordSuccessState()),
    );
  }
}

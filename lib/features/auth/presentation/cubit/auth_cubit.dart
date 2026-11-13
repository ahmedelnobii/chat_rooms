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
    res.fold(
      (l) => emit(GoogleSignInErrorState(l.message)),
      (user) => emit(GoogleSignInSuccessState(user)),
    );
  }

  Future<void> signInWithGoogle() => continueWithGoogle();
}

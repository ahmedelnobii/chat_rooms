import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleUser = UserModel(
    name: 'Ahmed',
    email: 'ahmed@example.com',
    userID: 'u-1',
  );

  test('login emits LoginSuccessState and sets currentUser on success', () async {
    final cubit = AuthCubit(_FakeAuthRepo(loginResult: Right(sampleUser)));

    await cubit.login(email: 'ahmed@example.com', password: 'password123');

    expect(cubit.currentUser, same(sampleUser));
    expect(cubit.state, isA<LoginSuccessState>());
    await cubit.close();
  });

  test('login emits LoginErrorState on failure', () async {
    final cubit = AuthCubit(
      _FakeAuthRepo(loginResult: Left(Failer('Invalid credentials'))),
    );

    await cubit.login(email: 'ahmed@example.com', password: 'wrong');

    expect(cubit.currentUser, isNull);
    expect(cubit.state, isA<LoginErrorState>());
    expect((cubit.state as LoginErrorState).error, 'Invalid credentials');
    await cubit.close();
  });

  test('register emits RegisterSuccessState on success', () async {
    final cubit = AuthCubit(_FakeAuthRepo());

    await cubit.register(
      name: 'Ahmed',
      email: 'ahmed@example.com',
      password: 'password123',
    );

    expect(cubit.state, isA<RegisterSuccessState>());
    await cubit.close();
  });

  test('continueWithGoogle emits GoogleSignInSuccessState and stores user', () async {
    final cubit = AuthCubit(_FakeAuthRepo(googleResult: Right(sampleUser)));

    await cubit.continueWithGoogle();

    expect(cubit.currentUser, same(sampleUser));
    expect(cubit.state, isA<GoogleSignInSuccessState>());
    await cubit.close();
  });

  test('checkSession emits SessionActiveState when logged in and SessionExpiredState when null', () async {
    final activeCubit = AuthCubit(
      _FakeAuthRepo(currentUserResult: Right(sampleUser)),
    );
    await activeCubit.checkSession();
    expect(activeCubit.state, isA<SessionActiveState>());
    await activeCubit.close();

    final expiredCubit = AuthCubit(
      _FakeAuthRepo(currentUserResult: const Right(null)),
    );
    await expiredCubit.checkSession();
    expect(expiredCubit.state, isA<SessionExpiredState>());
    await expiredCubit.close();
  });

  test('resetPassword emits ResetPasswordSuccessState on success and ResetPasswordErrorState on failure', () async {
    final okCubit = AuthCubit(_FakeAuthRepo());
    await okCubit.resetPassword(email: 'ahmed@example.com');
    expect(okCubit.state, isA<ResetPasswordSuccessState>());
    await okCubit.close();

    final errCubit = AuthCubit(
      _FakeAuthRepo(resetResult: Left(Failer('No account found'))),
    );
    await errCubit.resetPassword(email: 'unknown@example.com');
    expect(errCubit.state, isA<ResetPasswordErrorState>());
    await errCubit.close();
  });

  test('signOut clears currentUser and emits AuthInitialState', () async {
    final repo = _FakeAuthRepo(loginResult: Right(sampleUser));
    final cubit = AuthCubit(repo);

    await cubit.login(email: 'ahmed@example.com', password: 'password123');
    expect(cubit.currentUser, same(sampleUser));

    await cubit.signOut();

    expect(repo.signOutCalled, isTrue);
    expect(cubit.currentUser, isNull);
    expect(cubit.state, isA<AuthInitialState>());
    await cubit.close();
  });
}

class _FakeAuthRepo implements AuthRepo {
  final Either<Failer, UserModel>? loginResult;
  final Either<Failer, UserModel>? googleResult;
  final Either<Failer, UserModel?> currentUserResult;
  final Either<Failer, void> resetResult;
  bool signOutCalled = false;

  _FakeAuthRepo({
    this.loginResult,
    this.googleResult,
    this.currentUserResult = const Right(null),
    this.resetResult = const Right(null),
  });

  @override
  Future<Either<Failer, UserModel>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async => loginResult ?? Left(Failer('Login failed'));

  @override
  Future<Either<Failer, void>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async => const Right(null);

  @override
  Future<Either<Failer, UserModel>> continueWithGoogle() async =>
      googleResult ?? Left(Failer('Google sign-in failed'));

  @override
  Future<Either<Failer, UserModel?>> getCurrentUser() async =>
      currentUserResult;

  @override
  Future<Either<Failer, void>> resetPassword(String email) async => resetResult;

  @override
  Future<Either<Failer, void>> signOut() async {
    signOutCalled = true;
    return const Right(null);
  }
}

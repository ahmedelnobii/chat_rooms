import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/splash/splash_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('navigates to Home when session is active', (tester) async {
    final user = UserModel(
      name: 'Ahmed',
      email: 'ahmed@example.com',
      userID: 'u-1',
    );
    final authCubit = AuthCubit(_FakeAuthRepo(Right(user)));

    await tester.pumpWidget(_buildSplashApp(authCubit));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
    await authCubit.close();
  });

  testWidgets('navigates to Login when session is expired', (tester) async {
    final authCubit = AuthCubit(_FakeAuthRepo(const Right(null)));

    await tester.pumpWidget(_buildSplashApp(authCubit));
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
    await authCubit.close();
  });
}

Widget _buildSplashApp(AuthCubit authCubit) {
  final router = GoRouter(
    initialLocation: AppRouts.splashScreen,
    routes: [
      GoRoute(
        path: AppRouts.splashScreen,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRouts.homeScreen,
        builder: (_, _) => const Scaffold(body: Text('Home Page')),
      ),
      GoRoute(
        path: AppRouts.loginScreen,
        builder: (_, _) => const Scaffold(body: Text('Login Page')),
      ),
    ],
  );

  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => BlocProvider.value(
      value: authCubit,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}

class _FakeAuthRepo implements AuthRepo {
  final Either<Failer, UserModel?> currentUserResult;

  _FakeAuthRepo(this.currentUserResult);

  @override
  Future<Either<Failer, UserModel?>> getCurrentUser() async =>
      currentUserResult;

  @override
  Future<Either<Failer, UserModel>> continueWithGoogle() async =>
      Left(Failer('unused'));

  @override
  Future<Either<Failer, void>> resetPassword(String email) async =>
      const Right(null);

  @override
  Future<Either<Failer, UserModel>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async => Left(Failer('unused'));

  @override
  Future<Either<Failer, void>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async => const Right(null);

  @override
  Future<Either<Failer, void>> signOut() async => const Right(null);
}

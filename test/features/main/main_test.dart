import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/main/main_screen.dart';
import 'package:chat_rooms/features/profile/data/repo/profile_repo.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(_FakeProfileRepo()),
    );
    getIt.registerFactory<LikedCubit>(
      () => LikedCubit(_FakeLikedRepo()),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('goto maps bottom navigation indices to route paths', () {
    expect(goto(0), AppRouts.homeScreen);
    expect(goto(1), AppRouts.likedScreen);
    expect(goto(2), AppRouts.profileScreen);
  });

  testWidgets('MainScreen highlights active tab and switches routes on tap', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRouts.homeScreen,
      routes: [
        ShellRoute(
          builder: (_, _, child) => MainScreen(child: child),
          routes: [
            GoRoute(
              path: AppRouts.homeScreen,
              builder: (_, _) => const Text('Home Content'),
            ),
            GoRoute(
              path: AppRouts.likedScreen,
              builder: (_, _) => const Text('Liked Content'),
            ),
            GoRoute(
              path: AppRouts.profileScreen,
              builder: (_, _) => const Text('Profile Content'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home Content'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.text('liked'));
    await tester.pumpAndSettle();

    expect(find.text('Liked Content'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}

class _FakeProfileRepo implements ProfileRepo {
  @override
  Future<Either<Failer, UserModel?>> getProfile() async => const Right(null);
}

class _FakeLikedRepo implements LikedRepo {
  @override
  Stream<List<RoomModel>> getLikedRooms() => const Stream.empty();

  @override
  Future<Either<Failer, void>> addLikedRoom(RoomModel room) async =>
      const Right(null);

  @override
  Future<Either<Failer, void>> removeLikedRoom(String roomID) async =>
      const Right(null);
}

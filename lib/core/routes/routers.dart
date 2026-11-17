import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/presentation/view/login_screen.dart';
import 'package:chat_rooms/features/auth/presentation/view/register_screen.dart';
import 'package:chat_rooms/features/chat/presentation/view/chat_screen.dart';
import 'package:chat_rooms/features/chat/presentation/view/room_invite_screen.dart';
import 'package:chat_rooms/features/create_room/presentation/view/create_room_screen.dart';
import 'package:chat_rooms/features/home/presentation/view/home_screen.dart';
import 'package:chat_rooms/features/liked/presentation/view/liked_screen.dart';
import 'package:chat_rooms/features/main/main_screen.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/presentation/view/profile_screen.dart';
import 'package:chat_rooms/features/update_profile/presentation/view/update_profile_screen.dart';
import 'package:chat_rooms/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routers = GoRouter(
  routes: [
    GoRoute(
      path: AppRouts.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: AppRouts.loginScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: LoginScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRouts.registerScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: RegisterScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: "${AppRouts.roomInviteScreen}/:id",
      builder: (context, state) {
        final roomID = state.pathParameters["id"]!;
        return RoomInviteScreen(roomID: roomID);
      },
    ),
    GoRoute(
      path: "${AppRouts.chatScreen}/:id",
      pageBuilder: (context, state) {
        final String roomID = state.pathParameters["id"] as String;
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: ChatScreen(roomID),
          transitionDuration: const Duration(milliseconds: 100),
          reverseTransitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRouts.createRoomScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CreateRoomScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRouts.updateProfileScreen,
      pageBuilder: (context, state) {
        final initialProfile = state.extra is UserModel
            ? state.extra as UserModel
            : null;
        return CustomTransitionPage<UserModel?>(
          key: state.pageKey,
          child: UpdateProfileScreen(initialProfile: initialProfile),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
        );
      },
    ),

    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: AppRouts.homeScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),

              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        GoRoute(
          path: AppRouts.likedScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LikedScreen(),

              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        GoRoute(
          path: AppRouts.profileScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const ProfileScreen(),

              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
      ],
    ),
  ],
);

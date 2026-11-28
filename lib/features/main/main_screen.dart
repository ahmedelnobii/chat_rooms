import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRouts.likedScreen)) return 1;
    if (location.startsWith(AppRouts.profileScreen)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => getIt<LikedCubit>()..loadLikedRooms()),
      ],
      child: Scaffold(
        floatingActionButton: currentIndex == 0
            ? FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: AppColors.primary,
                onPressed: () {
                  context.push(AppRouts.createRoomScreen);
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        extendBody: true,
        body: widget.child,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h, right: 8.w, left: 8.w),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16.r),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: BottomNavigationBar(
                  backgroundColor: Colors.grey.shade200,
                  selectedItemColor: AppColors.primary,
                  currentIndex: currentIndex,
                  onTap: (value) {
                    context.go(goto(value));
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message_rounded),
                      label: "chats",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      label: "liked",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String goto(int index) {
  switch (index) {
    case 0:
      return AppRouts.homeScreen;
    case 1:
      return AppRouts.likedScreen;
    case 2:
      return AppRouts.profileScreen;
  }
  return AppRouts.homeScreen;
}

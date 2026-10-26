import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 8.w, left: 8.w),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16.r),
          child: BottomNavigationBar(
            backgroundColor: Colors.grey.shade200,
            selectedItemColor: AppColors.primiary,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
              context.go(goto(value));
            },
            items: [
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
  return "";
}

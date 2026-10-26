import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:flutter/material.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.go(AppRouts.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              isAntiAlias: true,
              fit: BoxFit.cover,
              image: AssetImage(AppImages.splashImage),
              width: double.infinity,
              height: 500.h,
            ),
            CircularProgressIndicator(
              color: const Color.fromARGB(255, 4, 12, 253),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

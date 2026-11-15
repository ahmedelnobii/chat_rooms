import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Check if the Firebase session is still active
    context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SessionActiveState) {
          // Session found → go straight to home
          context.go(AppRouts.homeScreen);
        } else if (state is SessionExpiredState) {
          // No session → ask the user to log in
          context.go(AppRouts.loginScreen);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                isAntiAlias: true,
                fit: BoxFit.contain,
                image: AssetImage(AppImages.chatIcon),
                width: double.infinity,
                height: 250.h,
              ),
              CircularProgressIndicator(
                color: const Color.fromARGB(255, 4, 12, 253),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

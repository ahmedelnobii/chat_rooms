import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:chat_rooms/features/auth/view/widgets/custom_text_fieled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            isAntiAlias: true,
            fit: BoxFit.cover,
            image: AssetImage(AppImages.loginHeader),
            width: double.infinity,
            height: 230.h,
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeOutCubic,
            builder: (context, progress, child) {
              return Opacity(
                opacity: progress,
                child: Transform.translate(
                  offset: Offset(0, 60 * (1 - progress)),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 200.h, left: 16.w, right: 16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(fontSize: 24.sp, fontWeight: .bold),
                        ),
                        Text(
                          "Sign in to jump right back into your communities and live watch parties.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: .w400,
                            color: Colors.grey,
                          ),
                        ),
                        CustomTextFieled(
                          fieldType: .email,
                          textField: "Email",
                          textEditingController: emailController,
                        ),

                        CustomTextFieled(
                          fieldType: .password,
                          textField: "Password",
                          textEditingController: passwordController,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle forget password logic here
                          },
                          child: Text(
                            textAlign: TextAlign.right,
                            "forget password?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: .w500,
                              color: AppColors.primiary,
                            ),
                          ),
                        ),
                        SizedBox(height: 36.h),
                        CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.go(AppRouts.homeScreen);
                            }
                          },
                          text: "Sign In",
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: .w400,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            InkWell(
                              onTap: () {
                                context.go(AppRouts.registerScreen);
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: .w500,
                                  color: AppColors.primiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                                indent: 16.w,
                                endIndent: 16.w,
                              ),
                            ),
                            Text(
                              "Or sign in with",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: .w400,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                                indent: 16.w,
                                endIndent: 16.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {},
                              tooltip: "Sign in with Google",
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primiary,
                                foregroundColor: Colors.white,
                                fixedSize: Size(48.w, 48.h),
                                shape: const CircleBorder(),
                              ),
                              icon: FittedBox(
                                child: Text(
                                  "G",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

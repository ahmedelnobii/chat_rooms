import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:chat_rooms/features/auth/view/widgets/custom_text_fieled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primiary, Colors.white],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.sp, fontWeight: .w500),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Create an account",
                      style: TextStyle(fontSize: 24.sp, fontWeight: .bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Join Chat Club to discover curated films and watch with friends.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: .w400,
                        color: Colors.grey,
                      ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 16.h),
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
                                      CustomTextFieled(
                                        fieldType: .name,
                                        textField: "Name",
                                        textEditingController: nameController,
                                      ),
                                      CustomTextFieled(
                                        fieldType: .email,
                                        textField: "Email",
                                        textEditingController: emailController,
                                      ),

                                      CustomTextFieled(
                                        fieldType: .password,
                                        textField: "Password",
                                        textEditingController:
                                            passwordController,
                                      ),

                                      SizedBox(height: 36.h),
                                      CustomButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            // Perform registration logic here
                                          }
                                        },
                                        text: "Sign Up",
                                      ),
                                      SizedBox(height: 16.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Already have an account?",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: .w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          InkWell(
                                            onTap: () {
                                              context.go(AppRouts.loginScreen);
                                            },
                                            child: Text(
                                              "Sign in",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              backgroundColor:
                                                  AppColors.primiary,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

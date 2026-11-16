import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.isLoading && state.profile == null) {
                return const _ProfileContent(profile: null);
              }

              if (state.error != null && state.profile == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }

              final profile = state.profile;
              if (profile == null) {
                return const Center(
                  child: Text('Please sign in to view your profile.'),
                );
              }

              return _ProfileContent(profile: profile);
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserModel? profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 34.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: profile == null
                ? const _ProfileInfoShimmer()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 55.r,
                        child: Text(
                          profile!.name.trim().isEmpty
                              ? '?'
                              : profile!.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 40.sp),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        profile!.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile!.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                      SizedBox(height: 8.h),
                      SelectableText(
                        'ID: ${profile!.userID}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Account',
            style: TextStyle(fontSize: 16.sp, color: Colors.blueGrey),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.go(AppRouts.loginScreen);
              },
              child: const ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Sign out', style: TextStyle(color: Colors.red)),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          if (MediaQuery.sizeOf(context).height < 500) SizedBox(height: 120.h),
        ],
      ),
    );
  }
}

class _ProfileInfoShimmer extends StatelessWidget {
  const _ProfileInfoShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: 110.r,
            height: 110.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12.h),
          _line(width: 150.w, height: 24.h),
          SizedBox(height: 8.h),
          _line(width: 180.w, height: 16.h),
          SizedBox(height: 16.h),
          _line(width: 120.w, height: 12.h),
        ],
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

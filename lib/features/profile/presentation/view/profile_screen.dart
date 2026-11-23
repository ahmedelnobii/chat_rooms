import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_state.dart';
import 'package:chat_rooms/features/profile/presentation/view/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                return const ProfileContent(profile: null);
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

              return ProfileContent(profile: profile);
            },
          ),
        ),
      ),
    );
  }
}

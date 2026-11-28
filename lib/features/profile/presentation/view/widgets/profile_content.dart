import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chat_rooms/features/profile/presentation/view/widgets/profile_info_shimmer.dart';
import 'package:chat_rooms/features/update_profile/presentation/view/widgets/reauth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileContent extends StatelessWidget {
  UserModel? profile;

  ProfileContent({super.key, required this.profile});

  Future<void> _onEditProfileTap(BuildContext context) async {
    final currentProfile = profile;
    if (currentProfile == null) return;

    final verified = await ReauthDialog.show(
      context,
      initialEmail: currentProfile.email,
    );
    if (verified != true || !context.mounted) return;

    final updatedUser = await context.push<UserModel?>(
      AppRouts.updateProfileScreen,
      extra: currentProfile,
    );
    if (updatedUser != null && context.mounted) {
      context.read<ProfileCubit>().setProfile(updatedUser);
    }
  }

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
                ? const ProfileInfoShimmer()
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: SelectableText(
                              'ID: ${profile!.userID}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          IconButton(
                            tooltip: 'Copy ID',
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 28.r,
                              minHeight: 28.r,
                            ),
                            icon: Icon(
                              Icons.copy_rounded,
                              size: 16.r,
                              color: AppColors.primiary,
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: profile!.userID),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
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
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: profile == null
                      ? null
                      : () => _onEditProfileTap(context),
                  child: const ListTile(
                    leading: Icon(
                      Icons.edit_outlined,
                      color: AppColors.primiary,
                    ),
                    title: Text(
                      'Edit profile',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ),
                Divider(height: 1, indent: 16.w, endIndent: 16.w),
                InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () async {
                    profile = null;
                    await context.read<AuthCubit>().signOut();
                    if (context.mounted) {
                      context.go(AppRouts.loginScreen);
                    }
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Sign out',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.sizeOf(context).height < 500) SizedBox(height: 120.h),
        ],
      ),
    );
  }
}

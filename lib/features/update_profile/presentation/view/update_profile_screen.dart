import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/create_room/presentation/view/widgets/create_room_text_field.dart';
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_cubit.dart';
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_state.dart';
import 'package:chat_rooms/features/update_profile/presentation/view/widgets/delete_account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? initialProfile;

  const UpdateProfileScreen({super.key, this.initialProfile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialName =
        widget.initialProfile?.name ??
        context.read<AuthCubit>().cuurentUser?.name ??
        '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context, bool isGoogleUser) {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = isGoogleUser
        ? null
        : (_newPasswordController.text.trim().isEmpty
              ? null
              : _newPasswordController.text.trim());

    context.read<UpdateProfileCubit>().updateProfile(
      name: _nameController.text.trim(),
      newPassword: newPassword,
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirmed = await DeleteAccountDialog.show(context);
    if (confirmed == true && context.mounted) {
      await context.read<UpdateProfileCubit>().deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UpdateProfileCubit>(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state.deleteError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deleteError!),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state.accountDeleted) {
            context.read<AuthCubit>().cuurentUser = null;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your account has been deleted.'),
                backgroundColor: Colors.green,
              ),
            );
            context.go(AppRouts.loginScreen);
            return;
          }

          if (state.saveError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.saveError!),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          final updatedUser = state.updatedUser;
          if (updatedUser != null) {
            context.read<AuthCubit>().cuurentUser = updatedUser;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop(updatedUser);
          }
        },
        builder: (context, state) {
          final isGoogleUser = state.isGoogleUser;
          final isSaving = state.isSaving;
          final isDeleting = state.isDeleting;
          final isBusy = isSaving || isDeleting;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                ),
                onPressed: isBusy ? null : () => context.pop(),
              ),
              title: Text(
                'Update Profile',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 72.w,
                              height: 72.h,
                              decoration: BoxDecoration(
                                color: AppColors.primiary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.primiary,
                                size: 38.r,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              'Personalize Your Account',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: GoogleFonts.satisfy().fontFamily,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              isGoogleUser
                                  ? 'Update your display name across all rooms and messages.'
                                  : 'Update your display name or set a new password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Form Card
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CreateRoomTextField(
                              label: 'Display Name',
                              hint: 'Enter your name',
                              prefixIcon: Icons.person_outline_rounded,
                              controller: _nameController,
                              textInputAction: isGoogleUser
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.trim().length < 3) {
                                  return 'Name must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            if (!isGoogleUser) ...[
                              SizedBox(height: 20.h),
                              CreateRoomTextField(
                                label: 'New Password (optional)',
                                hint: 'Leave blank to keep current password',
                                prefixIcon: Icons.lock_outline_rounded,
                                controller: _newPasswordController,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  if (value.trim().length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              CreateRoomTextField(
                                label: 'Confirm New Password',
                                hint: 'Re-enter new password',
                                prefixIcon: Icons.lock_reset_rounded,
                                controller: _confirmPasswordController,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  final newPass = _newPasswordController.text
                                      .trim();
                                  if (newPass.isEmpty &&
                                      (value == null || value.trim().isEmpty)) {
                                    return null;
                                  }
                                  if (value?.trim() != newPass) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            SizedBox(height: 28.h),
                            CustomButton(
                              text: isSaving
                                  ? 'Saving changes...'
                                  : 'Save Changes',
                              onPressed: isBusy
                                  ? null
                                  : () => _handleSave(context, isGoogleUser),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Danger Zone
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            CustomButton(
                              text: isDeleting
                                  ? 'Deleting account...'
                                  : 'Delete Account',
                              backgroundColor: Colors.redAccent,
                              onPressed: isBusy
                                  ? null
                                  : () => _handleDeleteAccount(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

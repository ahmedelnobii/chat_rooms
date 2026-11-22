import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_states.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/join_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomInviteScreen extends StatelessWidget {
  final String roomID;

  const RoomInviteScreen({super.key, required this.roomID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>(),
      child: _RoomInviteContent(roomID: roomID),
    );
  }
}

class _RoomInviteContent extends StatefulWidget {
  final String roomID;

  const _RoomInviteContent({required this.roomID});

  @override
  State<_RoomInviteContent> createState() => _RoomInviteContentState();
}

class _RoomInviteContentState extends State<_RoomInviteContent> {
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkSession();
  }

  Future<void> _joinRoom(RoomModel room) async {
    if (_isJoining) return;
    _isJoining = true;

    final didJoin = await joinRoom(
      context,
      roomID: widget.roomID,
      isPrivate: room.isPrivate,
      room: room,
      replaceCurrentRoute: true,
    );

    if (!didJoin && mounted) {
      context.go(AppRouts.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SessionActiveState) {
              context.read<ChatCubit>().getRoom(widget.roomID);
            } else if (state is SessionExpiredState) {
              context.go(AppRouts.loginScreen);
            }
          },
        ),
        BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is GetRoomSuccess) {
              _joinRoom(state.room);
            }
          },
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.primiary],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(28.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Room icon / header
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: AppColors.primiary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Image.asset(
                                  AppImages.chatIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Title
                            Text(
                              "You're Invited!",
                              style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.satisfy().fontFamily,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Subtitle
                            Text(
                              state is GetRoomSuccess
                                  ? "Join \"${state.room.roomName}\" and start chatting"
                                  : "Opening your room, please wait…",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.aboreto().fontFamily,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 28.h),

                            // Error state
                            if (state is GetRoomError) ...[
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade400,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        state.msg,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomButton(
                                onPressed: () =>
                                    context.go(AppRouts.homeScreen),
                                text: "Browse Rooms",
                              ),
                            ] else ...[
                              // Loading indicator
                              SizedBox(
                                width: 36.w,
                                height: 36.w,
                                child: CircularProgressIndicator(
                                  color: AppColors.primiary,
                                  strokeWidth: 3,
                                ),
                              ),
                            ],

                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

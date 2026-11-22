import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/delete_room_dialog.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/lively_chat_buttons.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/room_info_bottom_sheet.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String roomID;
  final RoomModel? initialRoom;

  const ChatAppBar({super.key, required this.roomID, this.initialRoom});

  @override
  Size get preferredSize => Size.fromHeight(68.h);

  Future<void> _shareRoom(BuildContext context, RoomModel room) async {
    final targetRoomID = room.roomID;
    final projectId = Firebase.app().options.projectId;
    if (targetRoomID == null || targetRoomID.isEmpty || projectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create a room link.')),
      );
      return;
    }

    final roomUri = Uri.https(
      '$projectId.web.app',
      '${AppRouts.roomInviteScreen}/$targetRoomID',
    );

    try {
      await SharePlus.instance.share(
        ShareParams(
          uri: roomUri,
          subject: 'Join ${room.roomName} on Chat Rooms',
        ),
      );
    } on PlatformException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to share this room: ${error.message}')),
      );
    }
  }

  Future<void> _confirmDeleteRoom(BuildContext context, RoomModel room) async {
    final targetRoomID = room.roomID ?? roomID;
    if (targetRoomID.isEmpty) return;

    final shouldDelete = await DeleteRoomDialog.show(
      context,
      roomName: room.roomName,
    );

    if (shouldDelete == true && context.mounted) {
      await context.read<ChatCubit>().deleteRoom(targetRoomID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 68.h,
      elevation: 0,
      leadingWidth: 52.w,
      leading: Center(
        child: LivelyActionButton(
          tooltip: 'Back',
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18.r,
          ),
        ),
      ),
      title: _ChatAppBarTitle(initialRoom: initialRoom),
      backgroundColor: AppColors.primiary.withValues(alpha: .6),
      centerTitle: true,
      actions: [
        const _ChatLikeActionButton(),
        _ChatShareActionButton(onShare: _shareRoom),
        _ChatDeleteActionButton(onDelete: _confirmDeleteRoom),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(16),
        ),
      ),
    );
  }
}

class _ChatAppBarTitle extends StatelessWidget {
  final RoomModel? initialRoom;

  const _ChatAppBarTitle({this.initialRoom});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final liveRoom = context.read<ChatCubit>().room;
        final displayRoom = liveRoom ?? initialRoom;

        if (displayRoom == null) {
          if (state is GetRoomError) {
            return const Text('Room unavailable');
          }
          return Shimmer.fromColors(
            baseColor: Colors.white30,
            highlightColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 16.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 11.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          );
        }

        final memberCount = liveRoom?.members.length;
        final memberLabel = memberCount == null
            ? null
            : memberCount == 1
            ? '1 member'
            : '$memberCount members';

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: liveRoom == null
              ? null
              : () => RoomInfoBottomSheet.show(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayRoom.roomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
              ),
              Text(
                displayRoom.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 2.h),
              if (memberLabel != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        memberLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Shimmer.fromColors(
                  baseColor: Colors.white30,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 10.h,
                    width: 64.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatLikeActionButton extends StatelessWidget {
  const _ChatLikeActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, _) {
        final room = context.read<ChatCubit>().room;

        return BlocBuilder<LikedCubit, LikedState>(
          builder: (context, likedState) {
            final isLiked =
                room != null && likedState.containsRoom(room.roomID ?? '');
            final isDisabled =
                room == null || likedState.isLoading || likedState.isUpdating;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: LivelyActionButton(
                tooltip: isLiked ? 'Unlike room' : 'Like room',
                backgroundColor: isLiked
                    ? Colors.redAccent.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.2),
                borderColor: isLiked
                    ? Colors.redAccent.withValues(alpha: 0.45)
                    : Colors.white.withValues(alpha: 0.28),
                onPressed: isDisabled
                    ? null
                    : () => context.read<LikedCubit>().toggleLike(room),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    ),
                    child: child,
                  ),
                  child: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(isLiked),
                    color: isLiked ? const Color(0xFFFF4D6D) : Colors.white,
                    size: 20.r,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ChatShareActionButton extends StatelessWidget {
  final Future<void> Function(BuildContext context, RoomModel room) onShare;

  const _ChatShareActionButton({required this.onShare});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, _) {
        final room = context.read<ChatCubit>().room;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: LivelyActionButton(
            tooltip: 'Share room',
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            onPressed: room == null ? null : () => onShare(context, room),
            child: Icon(
              Icons.ios_share_rounded,
              color: Colors.white,
              size: 19.r,
            ),
          ),
        );
      },
    );
  }
}

class _ChatDeleteActionButton extends StatelessWidget {
  final Future<void> Function(BuildContext context, RoomModel room) onDelete;

  const _ChatDeleteActionButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final room = context.read<ChatCubit>().room;
        final currentUserId =
            context.read<AuthCubit>().cuurentUser?.userID ??
            FirebaseAuth.instance.currentUser?.uid;
        final isCreator =
            room != null &&
            currentUserId != null &&
            currentUserId.isNotEmpty &&
            room.creatorId == currentUserId;

        if (!isCreator) {
          return SizedBox(width: 6.w);
        }

        final isDeleting = state is DeleteRoomLoading;
        return Padding(
          padding: EdgeInsets.only(left: 3.w, right: 8.w),
          child: LivelyActionButton(
            tooltip: 'Delete room',
            backgroundColor: Colors.redAccent.withValues(alpha: 0.25),
            borderColor: Colors.redAccent.withValues(alpha: 0.45),
            onPressed: isDeleting ? null : () => onDelete(context, room),
            child: isDeleting
                ? SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.delete_outline_rounded,
                    color: const Color(0xFFFFE5E9),
                    size: 20.r,
                  ),
          ),
        );
      },
    );
  }
}

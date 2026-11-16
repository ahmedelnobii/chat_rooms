import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/join_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikedRoomWidget extends StatelessWidget {
  final RoomModel room;
  final bool isUpdating;
  final VoidCallback onUnlike;

  const LikedRoomWidget({
    super.key,
    required this.room,
    required this.isUpdating,
    required this.onUnlike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => joinRoom(
          context,
          roomID: room.roomID ?? '',
          isPrivate: room.isPrivate,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primiary.withValues(alpha: 0.1),
          backgroundImage: const AssetImage(AppImages.chatIcon),
        ),
        title: Text(
          room.roomName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          room.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (room.isPrivate)
              Icon(
                Icons.lock_outline,
                color: Colors.grey,
                size: 20.r,
              ),
            IconButton(
              tooltip: 'Unlike room',
              onPressed: isUpdating ? null : onUnlike,
              icon: isUpdating
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.favorite, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

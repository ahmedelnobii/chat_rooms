import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LikedRoomWidget extends StatefulWidget {
  bool isLiked = true;
  LikedRoomWidget({super.key, this.isLiked = true});

  @override
  State<LikedRoomWidget> createState() => _LikedRoomWidgetState();
}

class _LikedRoomWidgetState extends State<LikedRoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          context.push(AppRouts.chatScreen);
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage(
            AppImages.chatIcon,
          ), // Replace with your image asset
        ),
        title: Text('Room Name'),
        subtitle: Text('Room Description'),
        trailing: InkWell(
          onTap: () {
            setState(() {
              widget.isLiked = !widget.isLiked;
            });
          },
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.red : AppColors.primiary,
          ),
        ),
      ),
    );
  }
}

import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRoomIcon extends StatelessWidget {
  const CustomRoomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Image.asset(AppImages.chatIcon, fit: .cover),
            SizedBox(height: 10.h),
            Text(
              "Room Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: .bold,
              ),
            ),
            Spacer(),
            CustomButton(
              text: "Join",
              onPressed: () {},
              fontsize: 16,
              weight: .w400,
              padding: 4,
            ),
          ],
        ),
      ),
    );
  }
}

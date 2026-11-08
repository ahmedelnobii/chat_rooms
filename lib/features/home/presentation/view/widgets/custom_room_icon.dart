import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Image.asset(
              AppImages.chatIcon,
              fit: .contain,
              height: 65.h,
              width: 65.w,
            ),
            SizedBox(height: 10.h),
            Text(
              "Room Name",
              style: TextStyle(
                fontFamily: GoogleFonts.archivo().fontFamily,
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: .bold,
              ),
            ),
            Text(
              "room description  room descriptionroom descriptionroom descriptionroom descriptionroom description      ",
              style: TextStyle(
                fontFamily: GoogleFonts.archivo().fontFamily,
                color: Colors.grey,
                fontSize: 12.sp,
                fontWeight: .bold,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),

            Spacer(),
            CustomButton(
              text: "Join",
              onPressed: () {
                context.push(AppRouts.chatScreen);
              },
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

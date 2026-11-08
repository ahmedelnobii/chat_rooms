import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRoomIcon extends StatelessWidget {
  final String roomName;
  final String roomDescription;

  const CustomRoomIcon({
    super.key,
    this.roomName = "Room Name",
    this.roomDescription =
        "room description  room descriptionroom descriptionroom descriptionroom descriptionroom description      ",
  });

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(AppImages.chatIcon),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    roomName,
                    style: TextStyle(
                      fontFamily: GoogleFonts.archivo().fontFamily,
                      color: Colors.black,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          roomDescription,
                          style: TextStyle(
                            fontFamily: GoogleFonts.archivo().fontFamily,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 5.h),
            CustomButton(
              text: "Join",
              onPressed: () {
                context.push(AppRouts.chatScreen);
              },
              fontsize: 16,
              weight: FontWeight.w400,
              padding: 4,
            ),
          ],
        ),
      ),
    );
  }
}

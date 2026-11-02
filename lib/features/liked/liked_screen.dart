import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/liked/widgets/liked_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 50, // Replace with the actual number of liked rooms
                itemBuilder: (context, index) {
                  return LikedRoomWidget()
                      .animate(delay: index < 9 ? (index * 80).ms : 0.ms)
                      .fadeIn()
                      .slideY(
                        begin: 0.2,
                      ); // Replace with your liked room widget
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_rooms/features/liked/widgets/liked_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with the actual number of liked rooms
                itemBuilder: (context, index) {
                  return LikedRoomWidget(); // Replace with your liked room widget
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

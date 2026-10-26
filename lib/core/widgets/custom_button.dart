import 'package:flutter/material.dart';
import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontsize = 16,
    this.weight = .bold,
    this.padding = 16,
  });

  final String text;
  final VoidCallback onPressed;
  final double fontsize;
  final FontWeight weight;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primiary,
        foregroundColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding.r),
        child: Text(
          text,
          style: TextStyle(fontSize: fontsize.sp, fontWeight: weight),
        ),
      ),
    );
  }
}

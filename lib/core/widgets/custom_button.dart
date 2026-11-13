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
    this.backgroundColor = AppColors.primiary,
    this.forgroundColor = Colors.white,
  });

  final String text;
  final VoidCallback? onPressed;
  final double fontsize;
  final FontWeight weight;
  final double padding;
  final Color backgroundColor;
  final Color forgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: forgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding.r),
        child: Text(
          text,
          style: TextStyle(fontSize: fontsize, fontWeight: weight),
        ),
      ),
    );
  }
}

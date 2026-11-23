import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileInfoShimmer extends StatelessWidget {
  const ProfileInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: 110.r,
            height: 110.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12.h),
          _line(width: 150.w, height: 24.h),
          SizedBox(height: 8.h),
          _line(width: 180.w, height: 16.h),
          SizedBox(height: 16.h),
          _line(width: 120.w, height: 12.h),
        ],
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

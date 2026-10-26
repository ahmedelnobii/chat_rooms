import 'package:chat_rooms/features/home/view/widgets/custom_room_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedTab extends StatelessWidget {
  final String tab;
  const SelectedTab({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: true,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: 16.h, right: 16.h, left: 16.h),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  tab,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.sp,
                    fontWeight: .bold,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverGrid.builder(
            itemCount: 20,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.w,
              crossAxisCount: 2,
              childAspectRatio: 186.h / 286.w,
            ),
            itemBuilder: (_, _) => CustomRoomIcon(),
          ),
        ),
      ],
    );
  }
}

import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;

  const CustomTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TabBar(
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          labelColor: AppColors.primiary,
          unselectedLabelColor: Colors.grey.shade700,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          padding: EdgeInsets.zero,
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.fill,
          indicatorAnimation: TabIndicatorAnimation.elastic,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}

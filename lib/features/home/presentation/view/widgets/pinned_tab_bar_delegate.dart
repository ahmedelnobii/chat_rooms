import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/custom_app_bar_item.dart';
import 'package:flutter/material.dart';

class PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final CustomTabBar tabBar;

  const PinnedTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.background,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(PinnedTabBarDelegate oldDelegate) =>
      tabBar.tabs != oldDelegate.tabBar.tabs;
}

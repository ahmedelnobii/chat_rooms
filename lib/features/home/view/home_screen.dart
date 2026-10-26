import 'package:chat_rooms/features/home/view/widgets/custom_app_bar_item.dart';
import 'package:chat_rooms/features/home/view/widgets/selected_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tabs = ['My Rooms', 'All Rooms'];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F9FE),
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                pinned: false,
                forceElevated: innerBoxIsScrolled,
                title: const Text('Chat Club'),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedTabBarDelegate(
                  tabBar: CustomTabBar(tabs: tabs),
                ),
              ),
            ],
            body: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 70.h),
              child: TabBarView(
                children: tabs.map((tab) => SelectedTab(tab: tab)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final CustomTabBar tabBar;

  const _PinnedTabBarDelegate({required this.tabBar});

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
      color: Colors.white,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_PinnedTabBarDelegate oldDelegate) =>
      tabBar.tabs != oldDelegate.tabBar.tabs;
}

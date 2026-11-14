import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/custom_app_bar_item.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/selected_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const tabs = ['All Rooms', 'My Rooms'];

    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadRooms(),
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: const Color(0xffF6F9FE),
          body: SafeArea(
            bottom: false,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Color(0xffF6F9FE),
                  foregroundColor: Colors.black,
                  pinned: false,
                  forceElevated: innerBoxIsScrolled,
                  title: const Text('Chat Club'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
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
                padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 70.h),
                child: TabBarView(
                  children: tabs
                      .map((tab) => SelectedTab(isMyRooms: tab == 'My Rooms'))
                      .toList(),
                ),
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
      color: AppColors.background,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_PinnedTabBarDelegate oldDelegate) =>
      tabBar.tabs != oldDelegate.tabBar.tabs;
}

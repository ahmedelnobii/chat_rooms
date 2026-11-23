import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_cubit.dart';
import 'package:chat_rooms/features/search/presentation/view/widgets/search_bar_field.dart';
import 'package:chat_rooms/features/search/presentation/view/widgets/search_results_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Search Rooms',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Column(
              children: [
                SearchBarField(),
                Expanded(child: SearchResultsGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

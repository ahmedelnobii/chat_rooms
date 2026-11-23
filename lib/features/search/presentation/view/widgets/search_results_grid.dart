import 'package:chat_rooms/core/widgets/custom_room_icon.dart';
import 'package:chat_rooms/core/widgets/room_card_shimmer.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_cubit.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsGrid extends StatelessWidget {
  const SearchResultsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (!state.hasSearched) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 56.r,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Search for a room by name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.isLoading) {
          return GridView.builder(
            padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.w,
              crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2,
              childAspectRatio: 186 / 250,
            ),
            itemBuilder: (_, _) => const RoomCardShimmer(),
          );
        }

        if (state.error != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () =>
                        context.read<SearchCubit>().searchRooms(state.query),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.results.isEmpty) {
          return Center(
            child: Text(
              'No rooms found matching "${state.query}".',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
          itemCount: state.results.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.w,
            crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2,
            childAspectRatio: 186 / 250,
          ),
          itemBuilder: (_, index) {
            final room = state.results[index];
            return CustomRoomIcon(
              roomID: room.roomID ?? '',
              roomName: room.roomName,
              roomDescription: room.description,
              isPrivate: room.isPrivate,
              room: room,
            );
          },
        );
      },
    );
  }
}

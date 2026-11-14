import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_state.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/custom_room_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedTab extends StatelessWidget {
  final bool isMyRooms;
  const SelectedTab({super.key, required this.isMyRooms});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final rooms = isMyRooms ? state.myRooms : state.allRooms;
        final isLoading = isMyRooms
            ? state.isLoadingMyRooms
            : state.isLoadingAllRooms;
        final error = isMyRooms ? state.myRoomsError : state.allRoomsError;

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
                      isMyRooms ? 'My Rooms' : 'All Rooms',
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
            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          error,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () =>
                              context.read<HomeCubit>().loadRooms(),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (rooms.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    isMyRooms
                        ? 'You have not created any rooms yet.'
                        : 'No rooms found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverGrid.builder(
                  itemCount: rooms.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w,
                    crossAxisCount: MediaQuery.sizeOf(context).width > 650
                        ? 4
                        : 2,
                    childAspectRatio: 186 / 250,
                  ),
                  itemBuilder: (_, index) {
                    final room = rooms[index];
                    return CustomRoomIcon(
                      roomID: room.roomID ?? '',
                      roomName: room.roomName,
                      roomDescription: room.description,
                      isPrivate: room.isPrivate,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

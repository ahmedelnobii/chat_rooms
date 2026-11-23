import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/widgets/custom_room_icon.dart';
import 'package:chat_rooms/core/widgets/delete_room_dialog.dart';
import 'package:chat_rooms/core/widgets/room_card_shimmer.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedTab extends StatelessWidget {
  final bool isMyRooms;
  const SelectedTab({super.key, required this.isMyRooms});

  Future<void> _confirmDeleteRoom(BuildContext context, RoomModel room) async {
    final roomID = room.roomID;
    if (roomID == null || roomID.isEmpty) return;

    final shouldDelete = await DeleteRoomDialog.show(
      context,
      roomName: room.roomName,
    );

    if (shouldDelete == true && context.mounted) {
      final success = await context.read<HomeCubit>().deleteRoom(roomID);
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final err = context.read<HomeCubit>().state.deleteRoomError;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to delete room: ${err ?? "Unknown error"}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

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
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverGrid.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w,
                    crossAxisCount: MediaQuery.sizeOf(context).width > 650
                        ? 4
                        : 2,
                    childAspectRatio: 186 / 250,
                  ),
                  itemBuilder: (_, _) => const RoomCardShimmer(),
                ),
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
                    final currentUserId =
                        context.read<AuthCubit>().cuurentUser?.userID ??
                        FirebaseAuth.instance.currentUser?.uid;
                    final isCreator =
                        currentUserId != null &&
                        currentUserId.isNotEmpty &&
                        room.creatorId == currentUserId;

                    return CustomRoomIcon(
                      roomID: room.roomID ?? '',
                      roomName: room.roomName,
                      roomDescription: room.description,
                      isPrivate: room.isPrivate,
                      room: room,
                      onDelete: isCreator && !state.isDeletingRoom
                          ? () => _confirmDeleteRoom(context, room)
                          : null,
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

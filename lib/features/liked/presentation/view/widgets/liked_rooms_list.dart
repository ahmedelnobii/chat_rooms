import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:chat_rooms/features/liked/presentation/view/widgets/liked_room_shimmer.dart';
import 'package:chat_rooms/features/liked/presentation/view/widgets/liked_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikedRoomsList extends StatelessWidget {
  final LikedState state;

  const LikedRoomsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.rooms.isEmpty) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const LikedRoomShimmer(),
      );
    }

    if (state.error != null && state.rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => context.read<LikedCubit>().loadLikedRooms(),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (state.rooms.isEmpty) {
      return Center(
        child: Text(
          'Rooms you like will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80.h),
      itemCount: state.rooms.length,
      itemBuilder: (context, index) {
        final room = state.rooms[index];
        return LikedRoomWidget(
              room: room,
              isUpdating: state.isUpdating,
              onUnlike: () => context.read<LikedCubit>().toggleLike(room),
            )
            .animate(delay: index < 9 ? (index * 80).ms : 0.ms)
            .fadeIn()
            .slideY(begin: 0.2);
      },
    );
  }
}

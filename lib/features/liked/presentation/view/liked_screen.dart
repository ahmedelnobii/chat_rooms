import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:chat_rooms/features/liked/presentation/view/widgets/liked_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LikedCubit>()..loadLikedRooms(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocConsumer<LikedCubit, LikedState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12.h),
                    Text(
                      'Liked rooms',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(child: _buildRoomList(context, state)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomList(BuildContext context, LikedState state) {
    if (state.isLoading && state.rooms.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primiary),
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

import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/join_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoomInviteScreen extends StatelessWidget {
  final String roomID;

  const RoomInviteScreen({super.key, required this.roomID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>()..getRoom(roomID),
      child: _RoomInviteContent(roomID: roomID),
    );
  }
}

class _RoomInviteContent extends StatefulWidget {
  final String roomID;

  const _RoomInviteContent({required this.roomID});

  @override
  State<_RoomInviteContent> createState() => _RoomInviteContentState();
}

class _RoomInviteContentState extends State<_RoomInviteContent> {
  bool _isJoining = false;

  Future<void> _joinRoom(RoomModel room) async {
    if (_isJoining) return;
    _isJoining = true;

    final didJoin = await joinRoom(
      context,
      roomID: widget.roomID,
      isPrivate: room.isPrivate,
      replaceCurrentRoute: true,
    );

    if (!didJoin && mounted) {
      context.go(AppRouts.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is GetRoomSuccess) {
          _joinRoom(state.room);
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state is GetRoomError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Unable to open this room: ${state.msg}'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context.go(AppRouts.homeScreen),
                        child: const Text('Go to rooms'),
                      ),
                    ],
                  ),
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/room_invite_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomInviteScreen extends StatelessWidget {
  final String roomID;

  const RoomInviteScreen({super.key, required this.roomID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>(),
      child: RoomInviteContent(roomID: roomID),
    );
  }
}

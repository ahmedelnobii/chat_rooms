import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/room_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> joinRoom(
  BuildContext context, {
  required String roomID,
  required bool isPrivate,
}) async {
  if (!isPrivate) {
    await context.push("${AppRouts.chatScreen}/$roomID");
    return;
  }

  final passwordAccepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => getIt<RoomPasswordCubit>(),
      child: RoomPasswordDialog(roomID: roomID),
    ),
  );

  if (passwordAccepted == true && context.mounted) {
    await context.push("${AppRouts.chatScreen}/$roomID");
  }
}

import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/room_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<bool> joinRoom(
  BuildContext context, {
  required String roomID,
  required bool isPrivate,
  RoomModel? room,
  bool replaceCurrentRoute = false,
}) async {
  if (!isPrivate) {
    final path = "${AppRouts.chatScreen}/$roomID";
    if (replaceCurrentRoute) {
      context.go(path, extra: room);
    } else {
      await context.push(path, extra: room);
    }
    return true;
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
    final path = "${AppRouts.chatScreen}/$roomID";
    if (replaceCurrentRoute) {
      context.go(path, extra: room);
    } else {
      await context.push(path, extra: room);
    }
    return true;
  }

  return false;
}

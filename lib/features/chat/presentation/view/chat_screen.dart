import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_input_bar.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_messages_list.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String roomID;
  const ChatScreen(this.roomID, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.primiary],
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<LikedCubit>()..loadLikedRooms()),
          BlocProvider(
            create: (_) => getIt<ChatCubit>()
              ..getMessage(widget.roomID)
              ..getRoom(widget.roomID),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocListener<LikedCubit, LikedState>(
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
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Center(
                  child: RepaintBoundary(
                    child: Container(
                      height: 750.h,
                      width: 340.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ChatAppBar(roomID: widget.roomID),
                          Expanded(
                            child: ChatMessagesList(roomID: widget.roomID),
                          ),
                          ChatInputBar(roomID: widget.roomID),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

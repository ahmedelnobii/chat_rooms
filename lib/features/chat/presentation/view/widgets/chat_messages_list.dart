import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessagesList extends StatelessWidget {
  final String roomID;

  const ChatMessagesList({super.key, required this.roomID});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is SendMessageError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.msg)));
          }
          if (state is GetMessageError) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => PopScope(
                canPop: false,
                child: AlertDialog(
                  title: const Text('Unable to load messages'),
                  content: Text(state.msg),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Quit'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<ChatCubit>().getMessage(roomID);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is GetRoomError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unable to load room: ${state.msg}')),
            );
          }
          if (state is DeleteRoomError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to delete room: ${state.msg}'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (state is DeleteRoomSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Room deleted successfully.'),
                backgroundColor: Colors.green,
              ),
            );
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          final messages = state is GetMessageSuccess
              ? state.msgs
              : state is SendMessageLoading && state.msgs != null
              ? state.msgs!
              : context.read<ChatCubit>().messages;
          if ((state is GetMessageLoading || state is GetRoomLoading) &&
              messages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primiary),
            );
          }
          if (messages.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(12.r),
              child: const Center(
                child: Text(
                  "Let's start the conversation",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (_, i) {
              return ChatBubble(
                messageModel: messages[messages.length - 1 - i],
              );
            },
          );
        },
      ),
    );
  }
}

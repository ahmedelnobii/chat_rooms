import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel messageModel;
  const ChatBubble({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    final isFromSender =
        messageModel.senderID == context.read<AuthCubit>().cuurentUser?.userID;
    return Align(
      alignment: isFromSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: isFromSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              isFromSender ? "You" : messageModel.senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFromSender ? Colors.blue : Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isFromSender ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                messageModel.content,
                style: TextStyle(
                  color: isFromSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

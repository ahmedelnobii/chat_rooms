import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final bool isFromSender;
  const ChatBubble({super.key, this.isFromSender = true});

  @override
  Widget build(BuildContext context) {
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
              isFromSender ? "You" : "Other User",
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
                "Hello, this is a chat message!",
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

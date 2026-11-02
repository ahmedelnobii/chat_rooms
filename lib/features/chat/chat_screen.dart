import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  // final List<ChatBubble> chatBubbleList = [];
  final chatBubbleList = [
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(isFromSender: false), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(isFromSender: false), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(), // Replace with your chat bubble widget
    ChatBubble(isFromSender: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.primiary],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 750.h,
            width: 340.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text("Room Chat"),
                  backgroundColor: AppColors.primiary.withValues(alpha: .6),
                  centerTitle: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListView.builder(
                      reverse: true, // Reverse the order of chat bubbles
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type a message",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          );
                        }
                        return chatBubbleList[chatBubbleList.length - i];
                      },
                      // Reverse the order of chat bubbles
                      itemCount: chatBubbleList.length + 1,
                    ),
                  ),
                ),
                // Replace with your chat bubble widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}

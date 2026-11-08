import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLiked = false;
  static const chatBubbleList = [
    ChatBubble(),
    ChatBubble(isFromSender: false),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(isFromSender: false),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(),
    ChatBubble(isFromSender: false),
  ];

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
                  AppBar(
                    title: const Text("Room Chat"),
                    backgroundColor: AppColors.primiary.withValues(alpha: .6),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.black : Colors.white,
                        ),
                        onPressed: () => setState(() => _isLiked = !_isLiked),
                      ),
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: chatBubbleList.length,
                        itemBuilder: (_, i) {
                          return chatBubbleList[chatBubbleList.length - 1 - i];
                        },
                      ),
                    ),
                  ),
                  const _ChatInputBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Isolated widget for the input bar.
///
/// Listening to [MediaQuery.viewInsetsOf] only inside this small widget prevents
/// the entire [ChatScreen], gradient background, card container, and app bar
/// from rebuilding on every frame of the keyboard animation.
class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: EdgeInsets.all(8.w),
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
      ),
    );
  }
}

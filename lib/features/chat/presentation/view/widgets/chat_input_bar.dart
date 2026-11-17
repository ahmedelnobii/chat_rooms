import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/lively_chat_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Isolated widget for the input bar.
///
/// Listening to [MediaQuery.viewInsetsOf] only inside this small widget prevents
/// the entire [ChatScreen], gradient background, card container, and app bar
/// from rebuilding on every frame of the keyboard animation.
class ChatInputBar extends StatefulWidget {
  final String roomID;

  const ChatInputBar({super.key, required this.roomID});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final user = context.read<AuthCubit>().cuurentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to send a message.')),
      );
      return;
    }

    await context.read<ChatCubit>().sendMessage(
      MessageModel(
        content: content,
        senderName: user.name,
        roomID: widget.roomID,
        senderID: user.userID,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (_, state) {
        if (state is SendMessageLoading) {
          _controller.clear();
        }

        if (state is SendMessageError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
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
              SizedBox(width: 8.w),
              LivelySendButton(onPressed: _sendMessage),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/delete_room_dialog.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_state.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_bubble.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  final String roomID;
  ChatScreen(this.roomID);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // static const chatBubbleList = [
  //   ChatBubble(),
  //   ChatBubble(isFromSender: false),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(isFromSender: false),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(),
  //   ChatBubble(isFromSender: false),
  // ];

  Future<void> _shareRoom(BuildContext context, RoomModel room) async {
    final roomID = room.roomID;
    final projectId = Firebase.app().options.projectId;
    if (roomID == null || roomID.isEmpty || projectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create a room link.')),
      );
      return;
    }

    final roomUri = Uri.https(
      '$projectId.web.app',
      '${AppRouts.roomInviteScreen}/$roomID',
    );

    try {
      await SharePlus.instance.share(
        ShareParams(
          uri: roomUri,
          subject: 'Join ${room.roomName} on Chat Rooms',
        ),
      );
    } on PlatformException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to share this room: ${error.message}')),
      );
    }
  }

  Future<void> _confirmDeleteRoom(BuildContext context, RoomModel room) async {
    final roomID = room.roomID ?? widget.roomID;
    if (roomID.isEmpty) return;

    final shouldDelete = await DeleteRoomDialog.show(
      context,
      roomName: room.roomName,
    );

    if (shouldDelete == true && context.mounted) {
      await context.read<ChatCubit>().deleteRoom(roomID);
    }
  }

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
                          AppBar(
                            toolbarHeight: 68.h,
                            title: BlocBuilder<ChatCubit, ChatState>(
                              builder: (context, state) {
                                final room = context.read<ChatCubit>().room;
                                if (room == null) {
                                  if (state is GetRoomError) {
                                    return const Text('Room unavailable');
                                  }
                                  return Shimmer.fromColors(
                                    baseColor: Colors.white30,
                                    highlightColor: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 16.h,
                                          width: 130.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          height: 11.h,
                                          width: 200.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      room.roomName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      room.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            backgroundColor: AppColors.primiary.withValues(
                              alpha: .6,
                            ),
                            centerTitle: true,
                            actions: [
                              BlocBuilder<ChatCubit, ChatState>(
                                builder: (context, _) {
                                  final room = context.read<ChatCubit>().room;

                                  return BlocBuilder<LikedCubit, LikedState>(
                                    builder: (context, likedState) {
                                      final isLiked =
                                          room != null &&
                                          likedState.containsRoom(
                                            room.roomID ?? '',
                                          );
                                      final isDisabled =
                                          room == null ||
                                          likedState.isLoading ||
                                          likedState.isUpdating;

                                      return IconButton(
                                        tooltip: isLiked
                                            ? 'Unlike room'
                                            : 'Like room',
                                        icon: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isLiked
                                              ? Colors.redAccent
                                              : Colors.white,
                                        ),
                                        onPressed: isDisabled
                                            ? null
                                            : () => context
                                                  .read<LikedCubit>()
                                                  .toggleLike(room),
                                      );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<ChatCubit, ChatState>(
                                builder: (context, _) {
                                  final room = context.read<ChatCubit>().room;
                                  return IconButton(
                                    tooltip: 'Share room',
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    onPressed: room == null
                                        ? null
                                        : () => _shareRoom(context, room),
                                  );
                                },
                              ),
                              BlocBuilder<ChatCubit, ChatState>(
                                builder: (context, state) {
                                  final room = context.read<ChatCubit>().room;
                                  final currentUserId =
                                      context
                                          .read<AuthCubit>()
                                          .cuurentUser
                                          ?.userID ??
                                      FirebaseAuth.instance.currentUser?.uid;
                                  final isCreator =
                                      room != null &&
                                      currentUserId != null &&
                                      currentUserId.isNotEmpty &&
                                      room.creatorId == currentUserId;

                                  if (!isCreator) {
                                    return const SizedBox.shrink();
                                  }

                                  final isDeleting = state is DeleteRoomLoading;
                                  return IconButton(
                                    tooltip: 'Delete room',
                                    icon: isDeleting
                                        ? SizedBox(
                                            width: 18.r,
                                            height: 18.r,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                          ),
                                    onPressed: isDeleting
                                        ? null
                                        : () =>
                                              _confirmDeleteRoom(context, room),
                                  );
                                },
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
                              child: BlocConsumer<ChatCubit, ChatState>(
                                listener: (context, state) {
                                  if (state is SendMessageError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.msg)),
                                    );
                                  }
                                  if (state is GetMessageError) {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogContext) => PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          title: const Text(
                                            'Unable to load messages',
                                          ),
                                          content: Text(state.msg),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Quit'),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                                context
                                                    .read<ChatCubit>()
                                                    .getMessage(widget.roomID);
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
                                      SnackBar(
                                        content: Text(
                                          'Unable to load room: ${state.msg}',
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is DeleteRoomError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Unable to delete room: ${state.msg}',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                  if (state is DeleteRoomSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Room deleted successfully.',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                builder: (_, state) {
                                  final messages = state is GetMessageSuccess
                                      ? state.msgs
                                      : state is SendMessageLoading &&
                                            state.msgs != null
                                      ? state.msgs!
                                      : context.read<ChatCubit>().messages;
                                  if ((state is GetMessageLoading ||
                                          state is GetRoomLoading) &&
                                      messages.isEmpty) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primiary,
                                      ),
                                    );
                                  }
                                  if (messages.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.all(12.r),
                                      child: Center(
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
                                        messageModel:
                                            messages[messages.length - 1 - i],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          _ChatInputBar(roomID: widget.roomID),
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

/// Isolated widget for the input bar.
///
/// Listening to [MediaQuery.viewInsetsOf] only inside this small widget prevents
/// the entire [ChatScreen], gradient background, card container, and app bar
/// from rebuilding on every frame of the keyboard animation.
class _ChatInputBar extends StatefulWidget {
  final String roomID;

  const _ChatInputBar({required this.roomID});

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
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
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return CircleAvatar(
                    backgroundColor: AppColors.primiary,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

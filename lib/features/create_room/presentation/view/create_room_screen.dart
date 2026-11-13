import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/consts/app_images.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_cubit.dart';
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_states.dart';
import 'package:chat_rooms/features/create_room/presentation/view/widgets/create_room_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isValid = false;
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreateRoom(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final roomName = _nameController.text.trim();
      final roomDescription = _descriptionController.text.trim();
      final user = context.read<AuthCubit>().cuurentUser;
      if (user == null) return;
      debugPrint('Creating room: name=$roomName, description=$roomDescription');
      await context.read<CreateRoomCubit>().createRoom(
        RoomModel(
          creatorId: user.userID,
          creatorName: user.name,
          roomName: roomName,
          description: roomDescription,
        ),
      );
      // Form is validated - ready for cubit / backend integration
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateRoomCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                "Create Room",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Form(
                  autovalidateMode: .onUserInteraction,
                  onChanged: () {
                    setState(() {
                      isValid = _formKey.currentState!.validate();
                    });
                  },

                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header card
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 72.w,
                              height: 72.h,
                              decoration: BoxDecoration(
                                color: AppColors.primiary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  AppImages.chatIcon,
                                  width: 44.w,
                                  height: 44.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              "Start a New Community",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: GoogleFonts.satisfy().fontFamily,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Give your room a name and description to invite people to your space.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Form Container
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Room Name Field
                            CreateRoomTextField(
                              label: "Room Name",
                              hint: "e.g. Flutter Enthusiasts",
                              prefixIcon: Icons.meeting_room_outlined,
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter a room name";
                                }
                                if (value.trim().length < 3) {
                                  return "Room name must be at least 3 characters";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Room Description Field
                            CreateRoomTextField(
                              label: "Room Description",
                              hint:
                                  "Describe the purpose and topics of this room...",
                              prefixIcon: Icons.description_outlined,
                              controller: _descriptionController,
                              maxLines: 4,
                              minLines: 3,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter a room description";
                                }
                                if (value.trim().length < 5) {
                                  return "Description must be at least 5 characters";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 28.h),

                            // Submit Button
                            BlocConsumer<CreateRoomCubit, CreateRoomStates>(
                              listener: (context, state) {
                                if (state is CreateRoomSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Room created successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.fixed,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  context.pop();
                                }
                                if (state is CreateRoomError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.msg),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              builder: (_, state) {
                                if (state is CreateRoomLoading) {
                                  return CustomButton(
                                    text: "Create Room",
                                    onPressed: null,
                                  );
                                }
                                return CustomButton(
                                  text: "Create Room",
                                  onPressed: isValid
                                      ? () {
                                          _handleCreateRoom(context);
                                        }
                                      : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

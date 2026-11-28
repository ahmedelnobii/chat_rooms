import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/features/search/presentation/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarField extends StatefulWidget {
  const SearchBarField({super.key});

  @override
  State<SearchBarField> createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().searchRooms(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return TextField(
          controller: _controller,
          autofocus: true,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _triggerSearch(),
          style: TextStyle(color: Colors.black87, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: 'Search by name',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasText)
                  IconButton(
                    tooltip: 'Clear',
                    onPressed: _clearSearch,
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade600,
                    ),
                  ),
                IconButton(
                  tooltip: 'Search',
                  onPressed: _triggerSearch,
                  icon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

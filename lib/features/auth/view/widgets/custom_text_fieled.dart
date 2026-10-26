import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/helpers/app_validators.dart';
import 'package:chat_rooms/core/helpers/filed_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFieled extends StatefulWidget {
  final String textField;
  final TextEditingController textEditingController;
  final FieldType fieldType;

  const CustomTextFieled({
    required this.fieldType,
    required this.textField,
    required this.textEditingController,
  });

  @override
  State<CustomTextFieled> createState() => _CustomTextFieledState();
}

class _CustomTextFieledState extends State<CustomTextFieled> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SizedBox(height: 6.h),
        Text(
          widget.textField,
          style: TextStyle(fontSize: 13.sp, fontWeight: .w500),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          obscureText:
              widget.fieldType == FieldType.password && !isPasswordVisible,
          validator: validator(widget.fieldType),
          controller: widget.textEditingController,
          maxLines: 1,
          decoration: InputDecoration(
            suffixIcon: widget.fieldType == FieldType.password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : null,
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset(
                icon(widget.fieldType),
                width: 20.w,
                height: 20.h,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            filled: true,
            fillColor: AppColors.textFieldColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: "Enter your ${widget.textField}".toLowerCase(),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}

String? Function(String?)? validator(FieldType fieldType) {
  switch (fieldType) {
    case FieldType.name:
      return Validators.validateName;
    case FieldType.email:
      return Validators.validateEmail;
    case FieldType.password:
      return Validators.validatePassword;
  }
}

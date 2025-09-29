import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import '../../../../core/constants/size/size_app.dart';

class MyTextInputWidget extends StatefulWidget {
  const MyTextInputWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.hintText,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hintText;

  @override
  State<MyTextInputWidget> createState() => _MyTextInputWidgetState();
}

class _MyTextInputWidgetState extends State<MyTextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: context.textTheme.bodySmall?.copyWith(
        color: AppColor.defaultColor,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          size: IconSizeApp.iconSizeMedium,
          color: AppColor.mediumGrey,
        ),
        hintText: widget.hintText,
        hintStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColor.mediumGrey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),

        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mediumGrey, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),

        filled: true,
        fillColor: AppColor.superLightGrey,

        // Trường hợp bị lỗi
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

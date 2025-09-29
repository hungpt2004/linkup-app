import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class ContentPostInputWidget extends StatelessWidget {
  final TextEditingController? controller;

  const ContentPostInputWidget({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        debugPrint('🎯 ContentPostInputWidget onChanged: "$value"');
      },
      strutStyle: StrutStyle(
        fontSize: FontSizeApp.fontSizeSubMedium,
        height: 1,
        leading: 0.5,
      ),
      cursorColor: AppColor.mediumGrey,
      decoration: InputDecoration(
        enabledBorder: _buildContentInputOutlineBorder(),
        focusedBorder: _buildContentInputOutlineBorder(),
        errorBorder: _buildContentInputOutlineBorder(),
        hintText: 'What\'s on your mind?',
        hintStyle: TextStyle(
          fontSize: FontSizeApp.fontSizeSubMedium,
          color: AppColor.mediumGrey,
          fontWeight: FontWeight.bold,
        ),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: null,
      expands: false, // Không dùng Expanded ở đây
      style: context.textTheme.bodyLarge,
    );
  }

  // Tách border input form field
  OutlineInputBorder _buildContentInputOutlineBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.backgroundColor),
    );
  }
}

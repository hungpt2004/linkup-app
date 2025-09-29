import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class EditProfileTabAction extends StatelessWidget {
  const EditProfileTabAction({
    super.key,
    required this.optionTitle,
    required this.optionFunction,
  });

  final String optionTitle;
  final VoidCallback optionFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: PaddingSizeApp.paddingSizeMedium,
        vertical: PaddingSizeApp.paddingSizeSmall,
      ),
      leading: Text(
        optionTitle,
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColor.defaultColor,
        ),
      ),
      trailing: GestureDetector(
        onTap: optionFunction,
        child: Icon(
          Icons.arrow_forward_ios,
          size: IconSizeApp.iconSizeSmall,
          color: AppColor.defaultColor,
        ),
      ),
    );
  }
}

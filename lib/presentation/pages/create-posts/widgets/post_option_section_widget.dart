import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class PostOptionWidget extends StatelessWidget {
  const PostOptionWidget({
    super.key,
    required this.onTap,
    required this.iconPath,
    required this.name,
  });

  final VoidCallback onTap;
  final String iconPath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: AppColor.lightBlue,
      dense: false,
      focusColor: AppColor.defaultColor,
      hoverColor: AppColor.lightGrey,
      leading: SizedBox(
        width: ResponsiveSizeApp(context).widthPercent(30),
        height: ResponsiveSizeApp(context).heightPercent(30),
        child: SvgPicture.asset(iconPath),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: PaddingSizeApp.paddingSizeSmall,
      ),
      title: Text(
        name,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

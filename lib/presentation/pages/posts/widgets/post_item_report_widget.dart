import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart";
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class PostReportSectionWidget extends StatelessWidget {
  const PostReportSectionWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    this.mysubtitle,
    required this.function,
  });

  final String title;
  final String imageUrl;
  final String? mysubtitle;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 30,
        height: 30,
        child: ClipRRect(child: SvgPicture.asset(imageUrl)),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle:
          mysubtitle != null
              ? Text(
                mysubtitle!,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.mediumGrey,
                ),
              )
              : null,
      onTap: function,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class DividerWidget extends StatelessWidget {
  final double height;

  const DividerWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSizeApp(context).screenWidth,
      height: ResponsiveSizeApp(context).heightPercent(height),
      color: AppColor.lightGrey,
    );
  }
}

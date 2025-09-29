import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class EditProfileContainerLayout extends StatelessWidget {
  const EditProfileContainerLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      width: ResponsiveSizeApp(context).screenWidth * 0.88,
      child: child,
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColor.lightGrey, width: 0.8),
    );
  }
}

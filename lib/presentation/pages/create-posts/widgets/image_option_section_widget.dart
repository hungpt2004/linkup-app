import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class PickImageOptionWidget extends StatelessWidget {
  const PickImageOptionWidget({
    super.key,
    required this.titleOption,
    required this.functionOption,
    required this.iconOption,
  });

  final String titleOption;
  final String iconOption;
  final VoidCallback functionOption;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: functionOption,
      child: Row(
        children: [
          SvgPicture.asset(iconOption),
          WSpacing(10),
          Text(titleOption, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

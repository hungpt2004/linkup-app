import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

import '../../../themes/theme/responsive/app_responsive_size.dart';

class MySocialButtonWidget extends StatelessWidget {
  const MySocialButtonWidget({
    super.key,
    required this.func,
    required this.icon,
  });

  final VoidCallback func;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSizeApp(context).widthPercent(30),
      height: ResponsiveSizeApp(context).heightPercent(30),
      decoration: _containerStyle(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: ResponsiveSizeApp(context).widthPercent(30),
            height: ResponsiveSizeApp(context).heightPercent(30),
            child: Image(image: AssetImage(icon)),
          ),
        ),
      ),
    );
  }

  BoxDecoration _containerStyle(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: context.colorScheme.primary, width: 0.8),
    );
  }
}

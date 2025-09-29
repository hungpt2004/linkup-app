import 'package:flutter/cupertino.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class SettingPostLayout extends StatefulWidget {
  const SettingPostLayout({super.key, required this.children});

  final List<Widget> children;

  @override
  State<SettingPostLayout> createState() => _SettingPostLayoutState();
}

class _SettingPostLayoutState extends State<SettingPostLayout> {
  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: ResponsiveSizeApp(context).moderateScale(70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: widget.children,
      ),
    );
  }
}

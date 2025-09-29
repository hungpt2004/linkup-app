import 'package:flutter/material.dart';
import 'package:vdiary_internship/data/models/tab/share_action_model.dart';

class ShareActionSectionWidget extends StatelessWidget {
  const ShareActionSectionWidget({
    super.key,
    required this.action,
    required this.onTap,
    required this.iconPath,
  });

  final ShareActionModel action;
  final VoidCallback onTap;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

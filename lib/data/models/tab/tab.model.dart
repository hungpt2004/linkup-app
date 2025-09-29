import 'package:flutter/widgets.dart';

class TabModel {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  TabModel({required this.text, required this.icon, this.onTap});
}

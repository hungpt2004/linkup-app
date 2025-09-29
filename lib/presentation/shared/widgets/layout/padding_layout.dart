import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';

class PaddingLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const PaddingLayout({super.key, required this.child, this.padding});

  factory PaddingLayout.all({
    required Widget child,
    double value = PaddingSizeApp.paddingSizeSmall,
  }) {
    return PaddingLayout(padding: EdgeInsets.all(value), child: child);
  }

  factory PaddingLayout.symmetric({
    required Widget child,
    double horizontal = 0,
    double vertical = 0,
  }) {
    return PaddingLayout(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }

  /// Factory cho padding only
  factory PaddingLayout.only({
    required Widget child,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return PaddingLayout(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding ?? EdgeInsets.all(0), child: child);
  }
}

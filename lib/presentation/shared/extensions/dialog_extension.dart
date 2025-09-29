import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/widgets/general_dialog/general_dialog_widget.dart';

extension DialogExtension on BuildContext {
  Future<T?> showCustomDialog<T>({
    required Widget child,
    String? title,
    String? subtitle,
    bool showCloseButton = true,
    bool barrierDismissible = true,
    double? width,
    double? height,
  }) {
    return MyGeneralDialogWidget.show<T>(
      context: this,
      child: child,
      title: title,
      subtitle: subtitle,
      showCloseButton: showCloseButton,
      barrierDismissible: barrierDismissible,
      width: width,
      height: height,
    );
  }
}

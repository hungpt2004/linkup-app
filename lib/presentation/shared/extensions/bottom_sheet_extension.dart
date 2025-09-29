import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/presentation/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';

extension BottomSheetExt on BuildContext {
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    Color? backgroundColor,
    double? borderRadius,
    required String text,
    double? height,
    bool isBack = true,
  }) {
    return showCustomBottomSheet<T>(
      context: this,
      child: child,
      title: text,
      height: height,
      isScrollControlled: isScrollControlled,
      isBack: isBack,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }
}

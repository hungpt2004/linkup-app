import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  double? height,
  bool isScrollControlled = true,
  Color? backgroundColor,
  double? borderRadius,
  bool isBack = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? Colors.white,
    showDragHandle: true,
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
    ),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius ?? 20),
      ),
    ),
    builder: (context) {
      final sheetContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaddingLayout.symmetric(
            child: Row(
              children: [
                isBack
                    ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColor.defaultColor,
                      ),
                      onPressed: () => AppNavigator.pop(context),
                    )
                    : SizedBox(),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                WSpacing(40),
              ],
            ),
          ),
          Divider(height: 1),
          HSpacing(5),
          Expanded(child: child),
        ],
      );

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:
            height != null
                ? SizedBox(height: height, child: sheetContent)
                : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: sheetContent,
                ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.currentPage = 'create-post',
    this.trailingText, // Chữ hiển thị ở bên phải (ví dụ: 'Post', 'Save')
    this.onLeadingPressed,
    this.onTrailingPressed, // Hành động khi bấm nút bên phải
    this.trailingTextColor, // Màu chữ cho nút bên phải
    this.trailingWidget,
    this.navigateContext, // Cho phép truyền widget tùy chỉnh hoàn toàn
  });

  final String title;
  final String currentPage;
  final String? trailingText;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTrailingPressed;
  final Color? trailingTextColor;
  final Widget? trailingWidget; // New property for custom widget
  final BuildContext? navigateContext;

  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 0,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.defaultColor,
              size: IconSizeApp.iconSizeMedium,
            ),
            onPressed: () {
              if (onLeadingPressed != null) {
                onLeadingPressed!();
              } else {
                switch (currentPage) {
                  case 'create-post':
                  case 'form-create-post':
                    AppNavigator.toDashboard(context, tabIndex: 0);
                    break;
                  case 'edit-image':
                    // Nếu có màn trước thì pop, nếu không thì về form create post
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      AppNavigator.toFormUpPost(context);
                    }
                    break;
                  case 'edit-profile':
                    AppNavigator.toProfileScreen(context);
                    break;
                  case 'edit-name':
                    AppNavigator.toEditProfielScreen(context);
                    break;
                  default:
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      AppNavigator.toDashboard(context, tabIndex: 0);
                    }
                    break;
                }
              }
            },
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (trailingWidget !=
              null) // Ưu tiên trailingWidget nếu được cung cấp
            trailingWidget!
          else if (trailingText !=
              null) // Nếu có trailingText, hiển thị TextButton
            TextButton(
              onPressed: onTrailingPressed, // Sử dụng callback mới
              child: Text(
                trailingText!, // Sử dụng chữ được truyền vào
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      trailingTextColor ??
                      Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            )
          else
            const WSpacing(48),
        ],
      ),
    );
  }
}

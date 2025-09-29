import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// Đây là một lớp tiện ích (utility class), không cần tạo đối tượng.
class ToastAppWidget {
  // Biến static để lưu FToast, đảm bảo chỉ khởi tạo một lần.
  static FToast? _fToast;

  static void _initToast(BuildContext context) {
    try {
      if (_fToast == null) {
        _fToast = FToast();
        _fToast!.init(context);
      }
    } catch (e) {
      debugPrint('Error initializing toast: $e');
    }
  }

  static void showSuccessToast(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onUndo,
  }) {
    _initToast(context);

    _fToast!.showToast(
      child: _buildToastContent(
        message: message,
        icon: FluentIcons.checkmark_circle_square_16_regular,
        backgroundColor: AppColor.backgroundColor,
        iconColor: AppColor.successGreen,
        onUndo: onUndo,
      ),
      gravity: ToastGravity.TOP,
      toastDuration: duration ?? const Duration(milliseconds: 3500),
    );
  }

  static void showErrorToast(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onUndo,
  }) {
    _initToast(context);

    _fToast!.showToast(
      child: _buildToastContent(
        message: message,
        icon: Icons.error_rounded,
        backgroundColor: AppColor.backgroundColor,
        iconColor: AppColor.errorRed,
        onUndo: onUndo,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: duration ?? const Duration(milliseconds: 3500),
    );
  }

  // Phương thức mới để hiển thị toast loading
  static void showLoadingToast(
    BuildContext context,
    String message, {
    ToastGravity? gravity,
  }) {
    _initToast(context);

    _fToast!.showToast(
      child: _buildToastContent(
        message: message,
        // Dùng CircularProgressIndicator cho hiệu ứng loading
        loadingIndicator: true,
        backgroundColor: AppColor.backgroundColor,
        iconColor: AppColor.lightBlue,
      ),
      gravity: gravity ?? ToastGravity.TOP,
      // Toast loading thường không tự động biến mất
      toastDuration: const Duration(hours: 1),
    );
  }

  // Phương thức để ẩn toast loading
  static void hideCurrentToast() {
    _fToast?.removeCustomToast();
  }

  static Widget _buildToastContent({
    required String message,
    IconData? icon,
    bool loadingIndicator = false,
    required Color backgroundColor,
    required Color iconColor,
    VoidCallback? onUndo,
  }) {
    // Sửa lại để chấp nhận icon hoặc loadingIndicator
    final Widget? leadingIcon =
        loadingIndicator
            ? SizedBox(
              width: IconSizeApp.iconSizeMedium,
              height: IconSizeApp.iconSizeMedium,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            )
            : (icon != null
                ? _ToastIcon(icon: icon, iconColor: iconColor)
                : null);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[leadingIcon, const WSpacing(8)],
          Flexible(child: _ToastMessage(message: message)),
          if (onUndo != null) ...[
            const WSpacing(12),
            _ToastUndoButton(onUndo: onUndo),
          ],
        ],
      ),
    );
  }
}

class _ToastIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  const _ToastIcon({required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: iconColor, size: IconSizeApp.iconSizeMedium);
  }
}

class _ToastMessage extends StatelessWidget {
  final String message;
  const _ToastMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style:
          context.textTheme.bodyMedium ??
          const TextStyle(
            fontSize: FontSizeApp.fontSizeSubMedium,
            color: AppColor.defaultColor,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ToastUndoButton extends StatelessWidget {
  final VoidCallback onUndo;
  const _ToastUndoButton({required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          ToastAppWidget._fToast?.removeCustomToast();
          onUndo();
        } catch (e) {
          debugPrint('Error in onUndo: $e');
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'UNDO',
          style:
              context.textTheme.bodyMedium?.copyWith(
                fontSize: FontSizeApp.fontSizeSmall,
                color: AppColor.defaultColor,
              ) ??
              const TextStyle(
                fontSize: FontSizeApp.fontSizeSmall,
                color: AppColor.defaultColor,
              ),
        ),
      ),
    );
  }
}

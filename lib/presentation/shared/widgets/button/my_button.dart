import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart'; // Giả định FontSizeApp có sẵn
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart'; // Giả định AppColor có sẵn

class MyAppButtonWidget extends StatelessWidget {
  const MyAppButtonWidget({
    super.key,
    required this.onPressed,
    this.text,
    this.buttonStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shadowColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.elevation = 5,
    this.child,
    this.minimumSize,
  });

  final VoidCallback? onPressed;
  final String? text;
  final ButtonStyle? buttonStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? overlayColor;
  final Color? shadowColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double elevation;
  final Widget? child;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    // Định nghĩa TextStyle mặc định ở đây để có thể truy cập context
    final TextStyle defaultTextStyle = TextStyle(
      // Sử dụng FontSizeApp.fontSizeInsideButton nếu có, ngược lại dùng 16.0
      fontSize: _getFontSizeInsideButton(context),
      fontWeight: FontWeight.w400,
      color: foregroundColor ?? Colors.white,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: _buildButtonStyle(
        context,
        defaultTextStyle,
      ), // Truyền defaultTextStyle vào
      child: _buildChildWidget(defaultTextStyle), // Truyền defaultTextStyle vào
    );
  }

  /// Helper để lấy kích thước font từ FontSizeApp hoặc giá trị mặc định.
  /// Đảm bảo MediaQuery.of(context) được gọi trong BuildContext hợp lệ.
  double _getFontSizeInsideButton(BuildContext context) {
    try {
      // Giả định FontSizeApp.fontSizeInsideButton là một hằng số hoặc getter an toàn
      // không cần MediaQuery trực tiếp tại điểm này nếu nó đã được tính toán sẵn
      return FontSizeApp.fontSizeInsideButton;
    } catch (e) {
      debugPrint(
        'Error accessing FontSizeApp.fontSizeInsideButton: $e. Using default 16.0',
      );
      return 16.0;
    }
  }

  /// Xây dựng widget con bên trong button.
  /// Ưu tiên [child] nếu được cung cấp, nếu không thì dùng [text].
  Widget _buildChildWidget(TextStyle defaultTextStyle) {
    if (child != null) {
      return child!;
    }
    return Text(
      text ?? '',
      textAlign: TextAlign.center,
      style:
          textStyle ??
          defaultTextStyle, // Sử dụng defaultTextStyle nếu textStyle không được cung cấp
    );
  }

  /// Xây dựng ButtonStyle dựa trên các tham số được truyền vào.
  /// Nếu [buttonStyle] được cung cấp, nó sẽ override tất cả các tham số khác.
  ButtonStyle _buildButtonStyle(
    BuildContext context,
    TextStyle defaultTextStyle,
  ) {
    if (buttonStyle != null) {
      return buttonStyle!;
    }

    return ButtonStyle(
      elevation: WidgetStatePropertyAll(elevation),
      backgroundColor: WidgetStatePropertyAll(
        backgroundColor ?? AppColor.lightBlue,
      ),
      foregroundColor: WidgetStatePropertyAll(foregroundColor ?? Colors.white),
      overlayColor: WidgetStatePropertyAll(
        overlayColor ??
            (backgroundColor ?? AppColor.lightBlue).withValues(alpha: 0.1),
      ),
      shadowColor: WidgetStatePropertyAll(
        shadowColor ?? Colors.black.withValues(alpha: 0.2),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
      padding: WidgetStatePropertyAll(
        padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      minimumSize:
          minimumSize != null ? WidgetStatePropertyAll(minimumSize) : null,
      textStyle: WidgetStatePropertyAll(
        textStyle ??
            defaultTextStyle, // Sử dụng defaultTextStyle nếu textStyle không được cung cấp
      ),
    );
  }
}

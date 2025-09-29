import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import '../../../../core/constants/size/size_app.dart';

class MyPasswordFormFieldWidget extends StatefulWidget {
  const MyPasswordFormFieldWidget({
    super.key,
    required this.controller,
    this.formKey,
    required this.func,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;
  final GlobalKey? formKey;
  final VoidCallback func;

  @override
  State<MyPasswordFormFieldWidget> createState() =>
      _MyPasswordFormFieldWidgetState();
}

class _MyPasswordFormFieldWidgetState extends State<MyPasswordFormFieldWidget> {
  // Biến giúp có thể xem hoặc không xem password
  bool _isObsecure = true;

  // Hàm logic xử lý isObsecure
  void _handleViewPassword() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formKey,
      style: _buildTextStyle(AppColor.defaultColor),
      controller: widget.controller,
      clipBehavior: Clip.antiAlias,
      textInputAction: TextInputAction.next,
      obscureText: _isObsecure,
      validator: _validatePassword,
      decoration: _buildInputDecoration(),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password again';
    }

    if (value.length < 6) {
      return 'Password must have more than 6 characters';
    }

    return null;
  }

  TextStyle _buildTextStyle(Color color) {
    return TextStyle(
      fontSize: FontSizeApp.fontSizeSubMedium,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: color,
        strokeAlign: BorderSide.strokeAlignCenter,
        width: 1,
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    const borderRadius = BorderRadius.all(Radius.circular(10));
    return InputDecoration(
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: borderRadius,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: AppColor.backgroundColor,
      hintText: '••••••••',
      hintStyle: _buildTextStyle(AppColor.lightGrey),
      labelText: widget.labelText,
      prefixIcon: Icon(FluentIcons.key_16_regular, color: AppColor.lightBlue),
      labelStyle: _buildTextStyle(AppColor.lightBlue),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: _buildBorder(AppColor.lightBlue),
      focusedBorder: _buildBorder(AppColor.lightBlue),
      errorBorder: _buildBorder(Colors.red),
      focusedErrorBorder: _buildBorder(Colors.red),
      suffixIcon: GestureDetector(
        onTap: _handleViewPassword,
        child: Icon(
          _isObsecure
              ? FluentIcons.eye_off_16_regular
              : FluentIcons.eye_16_regular,
          color: context.colorScheme.onSecondary,
        ),
      ),
    );
  }
}

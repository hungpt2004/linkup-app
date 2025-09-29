import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import '../../../../core/constants/size/size_app.dart';

class MyEmailFormFieldWidget extends StatelessWidget {
  const MyEmailFormFieldWidget({
    super.key,
    required this.controller,
    this.formKey,
    required this.func,
    required this.labelText,
    required this.hintText,
    required this.isEmail,
  });

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final GlobalKey? formKey;
  final VoidCallback func;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      controller: controller,
      style: _buildTextStyle(AppColor.defaultColor),
      clipBehavior: Clip.antiAlias,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: isEmail ? _validateEmail : _validateString,
      decoration: _buildInputDecoration(),
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
      hintText: hintText,
      hintStyle: _buildTextStyle(AppColor.lightGrey),
      labelText: labelText,
      labelStyle: _buildTextStyle(AppColor.lightBlue),
      prefixIcon: Icon(
        FluentIcons.person_16_regular,
        color: AppColor.lightBlue,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: _buildBorder(AppColor.lightBlue),
      focusedBorder: _buildBorder(AppColor.lightBlue),
      errorBorder: _buildBorder(AppColor.errorRed),
      focusedErrorBorder: _buildBorder(AppColor.errorRed),
    );
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
        style: BorderStyle.solid,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid format! ...@gmail.com';
    }

    return null;
  }

  String? _validateString(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    } else if (value.length < 3) {
      return 'Please enter name more than 3 characters';
    } else if (value is num) {
      return 'Name can\'t be a number';
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class SettingChatGroupListWidget extends StatefulWidget {
  const SettingChatGroupListWidget({super.key});

  @override
  State<SettingChatGroupListWidget> createState() =>
      _SettingChatGroupListWidgetState();
}

class _SettingChatGroupListWidgetState
    extends State<SettingChatGroupListWidget> {
  bool isThemeDark = false;
  bool isActiveStatusOn = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOptionSection(
          context,
          title: 'Theme Mode',
          value: isThemeDark,
          activeText: "Dark",
          inactiveText: "Light",
          activeColor: Colors.black87,
          inactiveColor: Colors.yellow.shade600,
          onChanged: (val) => setState(() => isThemeDark = val),
        ),
        _buildOptionSection(
          context,
          title: 'Active Status Change',
          value: isActiveStatusOn,
          activeText: "On",
          inactiveText: "Off",
          activeColor: Colors.green.shade600,
          inactiveColor: Colors.grey,
          onChanged: (val) => setState(() => isActiveStatusOn = val),
        ),
      ],
    );
  }

  /// Custom section dùng FlutterSwitch
  Widget _buildOptionSection(
    BuildContext context, {
    required String title,
    required bool value,
    required String activeText,
    required String inactiveText,
    required Color activeColor,
    required Color inactiveColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(ImagePath.settingNewIcon, width: 20, height: 20),
              WSpacing(12),
              Text(title, style: context.textTheme.bodyMedium),
            ],
          ),
          FlutterSwitch(
            width: 68,
            height: 30,
            toggleSize: 20,
            value: value,
            borderRadius: 20,
            padding: 5,
            duration: Duration(milliseconds: 100),
            activeText: activeText,
            inactiveText: inactiveText,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            showOnOff: true,
            valueFontSize: 12,
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }
}

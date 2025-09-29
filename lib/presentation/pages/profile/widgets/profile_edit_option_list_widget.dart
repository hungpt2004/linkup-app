import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/container_edit_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

// RELATIVE IMPORT
import 'profile_edit_option_item_widget.dart';

class EditProfileOptionWidget extends StatelessWidget {
  const EditProfileOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> optionsData = MockData.editProfileOptions(
      context,
    );
    return EditProfileContainerLayout(
      child: Column(
        children: [
          for (int i = 0; i < optionsData.length; i++) ...[
            EditProfileTabAction(
              optionTitle: optionsData[i]['optionTitle'] as String,
              optionFunction: optionsData[i]['optionFunction'] as VoidCallback,
            ),
            if (i != optionsData.length - 1) _dividerBottom(),
          ],
        ],
      ),
    );
  }
}

Widget _dividerBottom() {
  return Divider(height: 0.1, color: AppColor.lightGrey);
}

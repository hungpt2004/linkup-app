import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class FriendTagSectionWidget extends StatelessWidget {
  const FriendTagSectionWidget({
    super.key,
    required this.userInfo,
    required this.onTapCheckBox,
  });

  final UserModel userInfo;
  final ValueChanged<bool?>? onTapCheckBox;

  @override
  Widget build(BuildContext context) {
    final tagUserStore = context.tagUserStore;
    return PaddingLayout.symmetric(
      child: Observer(
        builder: (_) {
          final isChecked = tagUserStore.isSelected(userInfo.id!);
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (onTapCheckBox != null) {
                onTapCheckBox!(!isChecked);
              }
            },
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: PaddingSizeApp.paddingSizeSmall,
                vertical: PaddingSizeApp.paddingSizeSmall,
              ),
              leading: AvatarBoxShadowWidget(
                imageUrl: userInfo.avatarUrl ?? ImagePath.avatarDefault,
              ),
              title: Text(
                userInfo.name ?? 'Unknown',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.defaultColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Checkbox(
                value: isChecked,
                onChanged: onTapCheckBox,
                activeColor: AppColor.lightBlue,
                checkColor: AppColor.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

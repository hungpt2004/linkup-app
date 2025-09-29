import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/suggestion_title_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class SelectedUserListWidget extends StatelessWidget {
  const SelectedUserListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (context.tagUserStore.selectedUserIds.isNotEmpty &&
            context.tagUserStore.selectedUserInfor.isNotEmpty) {
          return Column(
            children: [
              SuggestionTitleWidget(
                text:
                    'Selected (${context.tagUserStore.selectedUserIds.length})',
              ),
              HSpacing(10),
              _buildListSelectedUser(context),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

Widget _buildListSelectedUser(BuildContext context) {
  return SizedBox(
    height: ResponsiveSizeApp(context).heightPercent(80),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: context.tagUserStore.selectedUserInfor.length,
      itemBuilder: (context, index) {
        final selectedUser = context.tagUserStore.selectedUserInfor[index];
        return _buildSelectedUserSectionWidget(
          context,
          selectedUser: selectedUser,
        );
      },
    ),
  );
}

Widget _buildSelectedUserSectionWidget(
  BuildContext context, {
  required UserModel selectedUser,
}) {
  return PaddingLayout.symmetric(
    horizontal: 10,
    child: SizedBox(
      width: 60,
      child: Column(
        children: [
          AvatarBoxShadowWidget(
            width: 50,
            height: 50,
            imageUrl: selectedUser.avatarUrl ?? ImagePath.avatarDefault,
          ),
          SizedBox(height: 4),
          Text(
            selectedUser.name ?? 'Unknown',
            style: context.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

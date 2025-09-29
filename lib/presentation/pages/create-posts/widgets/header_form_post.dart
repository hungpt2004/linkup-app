import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class HeaderInputWidget extends StatelessWidget {
  const HeaderInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final currentUser = context.authStore.userInfo;
        final tagUserStore = context.tagUserStore;
        final selectedUsers = tagUserStore.selectedUserInfor;
        if (selectedUsers.isEmpty) {
          return _buildSessionListUserTagEmpty(context, currentUser!['name']);
        }
        final List<TextSpan> displayText = _buildDisplayText(
          currentUser!['name'],
          selectedUsers,
          context,
        );
        return _buildSessionListUserTagNotEmpty(context, displayText);
      },
    );
  }

  List<TextSpan> _buildDisplayText(
    String currentUserName,
    List selectedUsers,
    BuildContext context,
  ) {
    final List<TextSpan> textSpans = [];

    textSpans.add(
      TextSpan(
        text: currentUserName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (selectedUsers.isNotEmpty) {
      textSpans.add(const TextSpan(text: ' with '));

      if (selectedUsers.length == 1) {
        textSpans.add(
          TextSpan(
            text: selectedUsers[0].name,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (selectedUsers.length == 2) {
        textSpans.add(
          TextSpan(
            text: selectedUsers[0].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        textSpans.add(const TextSpan(text: ' and '));
        textSpans.add(
          TextSpan(
            text: selectedUsers[1].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        int otherCount = selectedUsers.length - 1;
        textSpans.add(
          TextSpan(
            text: selectedUsers[0].name,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        textSpans.add(TextSpan(text: ' and '));
        textSpans.add(
          TextSpan(
            text: ' $otherCount other people${otherCount > 1 ? 's' : ''} ',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
    return textSpans;
  }
}

Widget _buildSessionListUserTagEmpty(BuildContext context, String text) {
  return _buildSessionUser(context, [
    TextSpan(text: text, style: const TextStyle(fontWeight: FontWeight.bold)),
  ]);
}

Widget _buildSessionListUserTagNotEmpty(
  BuildContext context,
  List<TextSpan> text,
) {
  return _buildSessionUser(context, text);
}

Widget _buildSessionUser(BuildContext context, List<TextSpan> textSpans) {
  return Observer(
    builder: (context) {
      final currentUser = context.authStore.userInfo;
      return PaddingLayout.only(
        left: 5,
        child: Row(
          children: [
            AvatarBoxShadowWidget(imageUrl: currentUser!['avatar']),
            WSpacing(15),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: textSpans,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColor.defaultColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

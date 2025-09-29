import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/user_avatar_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = context.authStore;
    final avatar =
        authStore.userInfo?['avatar'] as String? ?? ImagePath.avatarDefault;
    final name = authStore.userInfo?['name'] as String? ?? 'User';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary.withValues(alpha: 0.1),
            context.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          UserAvatarWidget(avatar: avatar),
          HSpacing(12),
          _buildUserName(context, name),
          HSpacing(4),
          _buildUserStatus(context),
        ],
      ),
    );
  }

  Widget _buildUserName(BuildContext context, String name) {
    return Text(
      name.isNotEmpty ? name : 'User Name',
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Online',
        style: context.textTheme.bodySmall?.copyWith(
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

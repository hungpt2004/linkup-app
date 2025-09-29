import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/drawer_list_tile_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';

class DrawerNotificationListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final BuildContext context;
  final VoidCallback onTap;
  final bool isActive;

  const DrawerNotificationListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.context,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final hasUnread = context.notificationStore.unreadNotificationCount > 0;
        return DrawerListileWidget(
          icon: icon,
          title: title,
          context: context,
          onTap: onTap,
          isActive: isActive,
          showUnreadIndicator: hasUnread,
        );
      },
    );
  }
}

// PACKAGE
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

// CUSTOM
import 'drawer_list_tile_widget.dart';
import 'drawer_notification_widget.dart';
import 'friends_section_widget.dart';
import '../../../themes/theme/app_theme.dart';
import '../../../themes/theme/responsive/app_responsive_size.dart';
import '../../../themes/theme/responsive/app_space_size.dart';

class DrawerNavigationWidget extends StatelessWidget {
  final Function(int) onPageChanged;
  final int currentPageIndex;
  final VoidCallback onLogout;

  const DrawerNavigationWidget({
    super.key,
    required this.onPageChanged,
    required this.currentPageIndex,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              DrawerListileWidget(
                icon: FluentIcons.home_12_regular,
                title: 'Home',
                context: context,
                onTap: () => onPageChanged(0),
                isActive: currentPageIndex == 0,
              ),
              DrawerListileWidget(
                icon: FluentIcons.people_12_regular,
                title: 'All Users',
                context: context,
                onTap: () => onPageChanged(1),
                isActive: currentPageIndex == 1,
              ),
              DrawerListileWidget(
                icon: FluentIcons.people_call_16_regular,
                title: 'Friends',
                context: context,
                onTap: () => onPageChanged(2),
                isActive: currentPageIndex == 2,
              ),
              DrawerNotificationListTile(
                icon: FluentIcons.people_add_16_regular,
                title: 'Notifications',
                context: context,
                onTap: () => onPageChanged(3),
                isActive: currentPageIndex == 3,
              ),
              DrawerListileWidget(
                icon: FluentIcons.person_accounts_24_regular,
                title: 'Profile',
                context: context,
                onTap: () => onPageChanged(4),
                isActive: currentPageIndex == 4,
              ),
              HSpacing(16),
              _buildDivider(context),
              HSpacing(16),
              FriendsSectionWidget(),
            ],
          ),
        ),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeApp(context).moderateScale(16),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            context.colorScheme.outline.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: DrawerListileWidget(
        icon: FluentIcons.door_16_regular,
        title: 'Log Out',
        context: context,
        onTap: onLogout,
        isActive: false,
        isLogout: true,
      ),
    );
  }
}

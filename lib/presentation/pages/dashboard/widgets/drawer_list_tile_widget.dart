import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// ignore: must_be_immutable
class DrawerListileWidget extends StatelessWidget {
  const DrawerListileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.context,
    required this.onTap,
    required this.isActive,
    this.showUnreadIndicator = false,
    this.isLogout = false,
  });

  final IconData icon;
  final String title;
  final BuildContext context;
  final VoidCallback onTap;
  final bool isActive;
  final bool showUnreadIndicator;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? context.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isActive
                        ? context.colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? context.colorScheme.primary
                            : isLogout
                            ? context.colorScheme.error.withValues(alpha: 0.1)
                            : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isActive
                            ? context.colorScheme.onPrimary
                            : isLogout
                            ? context.colorScheme.error
                            : context.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),

                WSpacing(16),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isActive
                              ? context.colorScheme.primary
                              : isLogout
                              ? context.colorScheme.error
                              : context.colorScheme.onSurface,
                    ),
                  ),
                ),

                // Unread indicator or arrow
                if (showUnreadIndicator)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.errorRed.withValues(alpha: 0.1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Observer(
                        builder:
                            (_) => Text(
                              '${context.notificationStore.unreadNotificationCount}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColor.errorRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                  )
                else if (isActive)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: context.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/data/models/notification/notification_model.dart';
import 'package:vdiary_internship/data/services/firebase_notification_service.dart';
import 'package:vdiary_internship/presentation/shared/extensions/animation_wrapper_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/utils/show_notification_type_utils.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/animation/animation_wrapper.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class NotificationSectionWidget extends StatefulWidget {
  const NotificationSectionWidget({super.key, required this.notificationIndex});

  final NotificationModel notificationIndex;

  @override
  State<NotificationSectionWidget> createState() =>
      _NotificationSectionWidgetState();
}

class _NotificationSectionWidgetState extends State<NotificationSectionWidget> {
  late Color color;
  late IconData icon;

  @override
  void initState() {
    super.initState();

    // Parse String -> Enum 1 lần duy nhất
    final typeEnum = TypeNotification.values.firstWhere(
      (e) => e.name == widget.notificationIndex.typeNotification,
      orElse: () => TypeNotification.system,
    );

    // Gọi hàm notificationTypeAndColor() để lấy map
    final typeMap = notificationTypeAndColor(typeEnum);
    final key = typeMap.keys.first;

    color = typeMap[key]?['color'] ?? Colors.grey;
    icon = typeMap[key]?['icon'] ?? FluentIcons.alert_24_regular;
  }

  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 16,
      vertical: 2,
      child: InkWell(
        onTap: () async {
          await FirebaseNotificationService().updateReadNotification(
            widget.notificationIndex.notificationId,
          );
        },
        child: Card(
          elevation: 4,
          surfaceTintColor: color.withValues(alpha: 0.1),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color),
                color: color.withValues(alpha: 0.15),
              ),
              child: Center(child: Icon(icon, color: color, size: 30)),
            ),
            title: Text(
              widget.notificationIndex.contentNotification,
              style: context.textTheme.bodyMedium,
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FluentIcons.clock_16_regular),
                WSpacing(5),
                Text(
                  formatMessageTime(widget.notificationIndex.createdAt),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                WSpacing(5),
                Text(
                  'Click to view notification',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColor.mediumGrey,
                  ),
                ),
              ],
            ),
            trailing:
                !widget.notificationIndex.isRead
                    ? Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColor.lightBlue.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    )
                    : SizedBox.shrink(),
          ),
        ).animate(
          type: AnimationType.fadeSlideUp,
          autoStart: true,
          curve: Curves.fastOutSlowIn,
          duration: Durations.long2,
        ),
      ),
    );
  }
}

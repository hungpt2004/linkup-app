import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/gen/image_path.dart';
import '../widgets/notification_section_widget.dart';
import '../../../shared/extensions/store_extension.dart';
import '../../../themes/theme/responsive/app_responsive_size.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          final notifications = context.notificationStore.ownNotifications;

          if (notifications.isEmpty) {
            return Center(
              child: SizedBox(
                width: ResponsiveSizeApp(context).widthPercent(250),
                height: ResponsiveSizeApp(context).heightPercent(250),
                child: ClipRRect(
                  child: Lottie.asset(ImagePath.lottieNotification),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (_, index) {
              final notificationIndex = notifications[index];
              return NotificationSectionWidget(
                notificationIndex: notificationIndex,
              );
            },
          );
        },
      ),
    );
  }
}

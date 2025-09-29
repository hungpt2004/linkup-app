import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/presence_service.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class UserActiveCheckWidget extends StatelessWidget {
  final String userId;
  final double size;
  final String? avatarUrl;

  const UserActiveCheckWidget({
    super.key,
    required this.userId,
    this.size = 60,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final presenceService = PresenceService();
    return StreamBuilder<Map<String, dynamic>?>(
      stream: presenceService.listenToUserStatus(userId),
      builder: (context, snapshot) {
        final status = snapshot.data?['state'] ?? "offline";
        final lastChanged = snapshot.data?['last_changed'];
        final isOnline = status == "online";
        debugPrint('LAST CHANGED: $lastChanged');
        return Stack(
          children: [
            // Avatar
            AvatarBoxShadowWidget(
              imageUrl: avatarUrl ?? ImagePath.avatarDefault,
              width: size,
              height: size,
            ),

            // Chấm online/offline
            Positioned(
              right: 1,
              bottom: -1,
              child: Container(
                width: size / 2.5,
                height: size / 2.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isOnline
                          ? AppColor.successGreen
                          : lastChanged != null
                          ? Colors.grey.shade300
                          : Colors.transparent,
                ),
                child:
                    lastChanged != null
                        ? Center(
                          child: Text(
                            formatLastSeen(lastChanged),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColor.defaultColor,
                              fontSize: 9,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

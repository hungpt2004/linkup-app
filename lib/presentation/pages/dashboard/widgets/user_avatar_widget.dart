import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class UserAvatarWidget extends StatelessWidget {
  final String avatar;

  const UserAvatarWidget({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => AppNavigator.toProfileScreen(context),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: Image.network(
                  avatar.isNotEmpty
                      ? '$avatar?v=${DateTime.now().millisecondsSinceEpoch}'
                      : ImagePath.avatarDefault,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: context.colorScheme.surface,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Online status indicator
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: context.colorScheme.surface, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class FriendsSectionWidget extends StatelessWidget {
  const FriendsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 16,
      child: Row(
        children: [
          Icon(
            Icons.people_outline,
            size: 16,
            color: context.colorScheme.primary,
          ),
          WSpacing(8),
          Text(
            'Friends',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Observer(
              builder:
                  (_) => Text(
                    '${context.friendStore.friends.length}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

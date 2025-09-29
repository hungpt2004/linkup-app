import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class ExitConfirmationDialog {
  static void show(BuildContext context) {
    context.showCustomDialog(
      height: 240,
      showCloseButton: false,
      barrierDismissible: true,
      width: ResponsiveSizeApp(context).screenWidth * 0.8,
      title: 'Exit app confirmation',
      subtitle: 'Are you sure you want to exit the application?',
      child: _buildContentExitConfirm(context),
    );
  }
}

Widget _buildContentExitConfirm(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'All unsaved changes will be lost.',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
      SizedBox(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.error,
                foregroundColor: context.colorScheme.onError,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

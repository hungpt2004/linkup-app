import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class LogoutConfirmationDialog {
  static void show(BuildContext context, VoidCallback onConfirm) {
    context.showCustomDialog(
      showCloseButton: false,
      title: 'Log out',
      subtitle: 'Are you sure you want to log out of your account?',
      child: _buildLogoutConfirmationContent(context, onConfirm),
    );
  }

  static Widget _buildLogoutConfirmationContent(
    BuildContext context,
    VoidCallback onConfirm,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}

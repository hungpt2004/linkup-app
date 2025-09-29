import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class MyGeneralDialogWidget extends StatelessWidget {
  const MyGeneralDialogWidget({
    super.key,
    required this.child,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.showCloseButton = true,
    this.title,
    this.subtitle,
  });

  final Widget child;
  final double? borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool showCloseButton;
  final String? title;
  final String? subtitle;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double borderRadius = 20,
    Color? backgroundColor,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    String barrierLabel = '',
    bool showCloseButton = true,
    String? title,
    String? subtitle,
    double? width,
    double? height,
  }) {
    return showGeneralDialog<T>(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder:
          (context, animation, secondaryAnimation) => Center(
            child: Material(
              color: Colors.transparent,
              child: MyGeneralDialogWidget(
                borderRadius: borderRadius,
                backgroundColor:
                    backgroundColor ?? Theme.of(context).colorScheme.surface,
                padding: padding,
                width: width,
                height: height,
                showCloseButton: showCloseButton,
                title: title,
                subtitle: subtitle,
                child: child,
              ),
            ),
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Improved animation with bounce effect
        final scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeInBack,
          ),
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width ?? ResponsiveSizeApp(context).screenWidth * 0.85,
      height: height,
      constraints: BoxConstraints(
        maxWidth: 400,
        maxHeight: ResponsiveSizeApp(context).screenHeight * 0.8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          // Main shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          // Secondary shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header section
            if (title != null || showCloseButton)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showCloseButton)
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          iconSize: 20,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Content section
            Flexible(
              child: Container(
                width: double.infinity,
                padding:
                    padding ??
                    const EdgeInsets.all(PaddingSizeApp.paddingSizeLarge),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

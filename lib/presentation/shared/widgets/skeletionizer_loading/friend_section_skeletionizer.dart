import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class FriendSectionSkeletonizer extends StatelessWidget {
  const FriendSectionSkeletonizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: AppColor.mediumGrey.withValues(alpha: 0.2),
          highlightColor: Colors.white,
          duration: const Duration(milliseconds: 1500),
        ),
        child: Card(
          elevation: 8,
          shadowColor: AppColor.defaultColor.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSkeleton(context),
              _infoSkeleton(context),
              _actionSkeleton(context),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header skeleton (ảnh cover)
Widget _headerSkeleton(BuildContext context) {
  return Container(
    height: ResponsiveSizeApp(context).heightPercent(140),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      color: AppColor.mediumGrey.withValues(alpha: 0.13),
    ),
  );
}

/// Info skeleton (tên, bạn chung, status)
Widget _infoSkeleton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 35, 16, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 16,
          color: AppColor.mediumGrey.withValues(alpha: 0.13),
        ),
        HSpacing(8),
        Row(
          children: [
            Container(
              width: 35,
              height: 25,
              decoration: BoxDecoration(
                color: AppColor.mediumGrey.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            WSpacing(8),
            Container(
              width: 60,
              height: 12,
              color: AppColor.mediumGrey.withValues(alpha: 0.13),
            ),
          ],
        ),
        HSpacing(12),
        Container(
          width: 60,
          height: 18,
          decoration: BoxDecoration(
            color: AppColor.mediumGrey.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    ),
  );
}

/// Action skeleton (2 button)
Widget _actionSkeleton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.mediumGrey.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        WSpacing(12),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.mediumGrey.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

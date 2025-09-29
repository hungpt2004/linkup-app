// lib/presentation/pages/home/widgets/card_post_skeleton_widget.dart

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class CardPostSkeletonWidget extends StatelessWidget {
  const CardPostSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          // 👈 giống CardPostSkeletonWidget
          baseColor: AppColor.mediumGrey.withValues(alpha: 0.2),
          highlightColor: Colors.white,
          duration: const Duration(milliseconds: 1500),
        ),
        child: PaddingLayout.symmetric(
          horizontal: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Skeleton
              _buildHeaderSkeleton(context),

              // Content Skeleton
              _buildContentSkeleton(),

              // Media Skeleton
              _buildMediaSkeleton(context),

              // Stats and Actions Skeleton
              _buildStatsAndActionsSkeleton(),

              const HSpacing(16),
              DividerWidget(height: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton(BuildContext context) {
    return PaddingLayout.symmetric(
      vertical: 16,
      child: Row(
        children: [
          const CircleAvatar(),
          WSpacing(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGrayBlock(width: 100, height: 12),
              HSpacing(4),
              _buildGrayBlock(width: 60, height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGrayBlock(width: double.infinity, height: 12),
        HSpacing(8),
        _buildGrayBlock(width: 250, height: 12),
        HSpacing(16),
      ],
    );
  }

  Widget _buildMediaSkeleton(BuildContext context) {
    return Container(
      height: 200,
      width: ResponsiveSizeApp(context).screenWidth,
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget _buildStatsAndActionsSkeleton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGrayBlock(width: 50, height: 12),
            _buildGrayBlock(width: 120, height: 12),
          ],
        ),
        HSpacing(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGrayBlock(width: 60, height: 24),
            _buildGrayBlock(width: 80, height: 24),
            _buildGrayBlock(width: 60, height: 24),
            _buildGrayBlock(width: 60, height: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildGrayBlock({required double width, required double height}) {
    return Container(width: width, height: height, color: AppColor.mediumGrey);
  }
}

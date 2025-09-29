import 'package:flutter/material.dart';

class StickySectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  StickySectionHeaderDelegate({
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant StickySectionHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}

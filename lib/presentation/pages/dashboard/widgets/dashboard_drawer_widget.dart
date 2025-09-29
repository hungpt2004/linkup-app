import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/drawer_header_widget.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/drawer_navigation_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class DashboardDrawerWidget extends StatelessWidget {
  final Function(int) onPageChanged;
  final int currentPageIndex;
  final VoidCallback onLogout;

  const DashboardDrawerWidget({
    super.key,
    required this.onPageChanged,
    required this.currentPageIndex,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSizeApp(context).screenHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.superLightGrey,
            context.colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Observer(
          builder:
              (_) => Column(
                children: [
                  HSpacing(50),
                  DrawerHeaderWidget(),
                  Expanded(
                    child: DrawerNavigationWidget(
                      onPageChanged: onPageChanged,
                      currentPageIndex: currentPageIndex,
                      onLogout: onLogout,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class AudienceOptionListTileWidget extends StatelessWidget {
  const AudienceOptionListTileWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    final audienceStore = context.audienceStore;
    return Observer(
      builder:
          (_) => ListTile(
            splashColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: ResponsiveSizeApp(context).widthPercent(30),
              height: ResponsiveSizeApp(context).heightPercent(30),
              child: SvgPicture.asset(imagePath),
            ),
            title: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.defaultColor,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColor.mediumGrey,
              ),
            ),
            trailing: Radio<String>(
              value: value,
              groupValue: audienceStore.typeAudience,
              onChanged: (val) {
                audienceStore.toggleChangeTypeAudience(val ?? '');
              },
            ),
            onTap: () {
              audienceStore.toggleChangeTypeAudience(value);
            },
          ),
    );
  }
}

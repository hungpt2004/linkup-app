import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/audience_option_section_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class FormAudienceBottomSheet extends StatelessWidget {
  const FormAudienceBottomSheet({super.key, required this.richTextBaseStyle});

  final TextStyle richTextBaseStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PaddingLayout.symmetric(
          horizontal: ResponsiveSizeApp(context).moderateScale(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Who can see your post?',
                    textAlign: TextAlign.start,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              HSpacing(10),
              Text(
                'Your post will show up in Feed, on your profile and in search the result',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.mediumGrey,
                ),
              ),
              HSpacing(8),
              _buildTitleDefaultOption(context, richTextBaseStyle),
              HSpacing(10),
              DividerWidget(height: 1),
              HSpacing(10),
              ...MockData.audienceOptions.map(
                (option) => AudienceOptionListTileWidget(
                  imagePath: option['icon']!,
                  title: option['title']!,
                  subtitle: option['subtitle']!,
                  value: option['value']!,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: ResponsiveSizeApp(context).screenWidth,
            height: ResponsiveSizeApp(context).heightPercent(120),
            decoration: _defaultOptionBoxDecoration(),
            child: Column(
              children: [
                _buildCheckBoxDefault(context),
                _buildDefaultOptionButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _defaultOptionBoxDecoration() {
    return BoxDecoration(
      color: AppColor.backgroundColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.lightGrey,
          blurRadius: 5,
          spreadRadius: 5,
          offset: Offset(-4, 0),
        ),
      ],
      border: Border(top: BorderSide(color: AppColor.lightGrey, width: 1)),
    );
  }
}

Widget _buildTitleDefaultOption(
  BuildContext context,
  TextStyle richTextBaseStyle,
) {
  return RichText(
    text: TextSpan(
      style: richTextBaseStyle,
      children: [
        TextSpan(text: 'Your default audience is set to '),
        TextSpan(
          text: 'Only me',
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.mediumGrey,
          ),
        ),
        TextSpan(
          text: ', but you can change the audience of this specific post.',
        ),
      ],
    ),
  );
}

Widget _buildCheckBoxDefault(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      PaddingLayout.only(
        left: 12,
        child: Text(
          'Set as default audience',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColor.mediumGrey,
          ),
        ),
      ),
      Checkbox(
        value: true,
        onChanged: (value) {},
        checkColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        fillColor: WidgetStatePropertyAll(AppColor.mediumGrey),
      ),
    ],
  );
}

Widget _buildDefaultOptionButton(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: PaddingSizeApp.paddingSizeSubMedium,
      vertical: PaddingSizeApp.paddingSizeSmall,
    ),
    width: ResponsiveSizeApp(context).screenWidth,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => AppNavigator.toFormUpPost(context),
      child: Text(
        'Done',
        style: context.textTheme.labelLarge?.copyWith(color: Colors.white),
      ),
    ),
  );
}

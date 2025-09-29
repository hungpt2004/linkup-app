import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class EditImageWidget extends StatelessWidget {
  const EditImageWidget(
    this.removeImageFunction,
    this.openBottomSheet, {
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;
  final VoidCallback? openBottomSheet;
  final VoidCallback? removeImageFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: ResponsiveSizeApp(context).screenWidth,
              height: 200,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: AppColor.superLightGrey),
                  bottom: BorderSide(width: 1, color: AppColor.superLightGrey),
                ),
              ),
              child: Center(
                child: ClipRRect(child: MyImageWidget(imageUrl: imageUrl)),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Row(
                children: [
                  _buildImageAction(
                    context,
                    openBottomSheet,
                    ImagePath.settingIcon,
                  ),
                  WSpacing(10),
                  _buildImageAction(
                    context,
                    removeImageFunction,
                    ImagePath.closeIcon,
                  ),
                ],
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Add a caption...',
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.mediumGrey,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: AppColor.lightGrey, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildImageAction(
  BuildContext context,
  VoidCallback? function,
  String iconPath,
) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: ResponsiveSizeApp(context).widthPercent(35),
      height: ResponsiveSizeApp(context).heightPercent(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppColor.defaultColor.withValues(alpha: 0.5),
      ),
      child: PaddingLayout.all(
        value: 5,
        child: SvgPicture.asset(iconPath, width: 15, height: 15),
      ),
    ),
  );
}

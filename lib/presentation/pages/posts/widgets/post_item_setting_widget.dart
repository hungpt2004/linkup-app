import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// ignore: must_be_immutable
class PostSettingSectionWidget extends StatelessWidget {
  PostSettingSectionWidget(
    this.func, {
    super.key,
    required this.text,
    required this.iconImage,
  });

  VoidCallback func;
  final String text;
  final String iconImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      splashColor: AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeApp(context).moderateScale(10),
          vertical: ResponsiveSizeApp(context).moderateScale(4),
        ),
        decoration: _boxDeration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconPrefix(iconImage, context),
            WSpacing(5),
            _buildTitle(text, context),
            _buildIconSuffix(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDeration() {
    return BoxDecoration(
      color: AppColor.superLightBlue,
      borderRadius: BorderRadius.circular(10),
    );
  }
}

Widget _buildIconPrefix(String imagePath, BuildContext context) {
  return SizedBox(
    width: ResponsiveSizeApp(context).widthPercent(IconSizeApp.iconSizeSmall),
    height: ResponsiveSizeApp(context).heightPercent(IconSizeApp.iconSizeSmall),
    child: Align(
      alignment: Alignment.center,
      child: SvgPicture.asset(imagePath),
    ),
  );
}

Widget _buildTitle(String text, BuildContext context) {
  return Text(
    text,
    style: TextStyle(
      fontSize: FontSizeApp.fontSizeSmall,
      fontWeight: FontWeight.bold,
      color: AppColor.lightBlue,
    ),
  );
}

Widget _buildIconSuffix() {
  return Icon(
    Icons.arrow_drop_down,
    size: IconSizeApp.iconSizeLarge,
    color: AppColor.lightBlue,
  );
}

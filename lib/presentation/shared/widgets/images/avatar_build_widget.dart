import 'package:flutter/cupertino.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class AvatarBoxShadowWidget extends StatelessWidget {
  const AvatarBoxShadowWidget({
    super.key,
    this.imageUrl = ImagePath.avatarDefault,
    this.width = 50,
    this.height = 50,
    this.radiusContainer = 40,
    this.radiusImage = 50,
    this.verticalVector = 0,
    this.horizontalVector = 2,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double radiusContainer;
  final double radiusImage;
  final double verticalVector;
  final double horizontalVector;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decorationContainer(),
      width: ResponsiveSizeApp(context).widthPercent(width),
      height: ResponsiveSizeApp(context).heightPercent(height),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSizeApp(context).moderateScale(1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiusImage),
          child: MyImageWidget(imageUrl: imageUrl),
        ),
      ),
    );
  }

  BoxDecoration _decorationContainer() => BoxDecoration(
    borderRadius: BorderRadius.circular(radiusContainer),
    boxShadow: [
      BoxShadow(
        color: AppColor.defaultColor.withValues(alpha: 0.15),
        blurRadius: 8,
        offset: Offset(verticalVector, horizontalVector),
      ),
    ],
  );
}

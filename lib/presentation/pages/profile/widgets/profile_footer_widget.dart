import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class CardProfileFooterWidget extends StatelessWidget {
  const CardProfileFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final currentUser = context.authStore.userInfo;
        var sizedBox = SizedBox(
          height: 50,
          child: Stack(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: MyImageWidget(imageUrl: currentUser!['avatar']),
                ),
              ),
              Positioned(
                right: 0,
                bottom: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColor.backgroundColor,
                  ),
                  child: Center(
                    child: ClipRRect(
                      child: PaddingLayout.all(
                        value: 1,
                        child: SvgPicture.asset(ImagePath.facebookIcon),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        var text = Text(
          '${currentUser['name']}',
          style: context.textTheme.bodyMedium,
        );
        var text2 = Text(
          'Facebook',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColor.mediumGrey,
          ),
        );
        var gestureDetector = GestureDetector(
          child: Icon(
            Icons.arrow_forward_ios,
            size: IconSizeApp.iconSizeSmall,
            color: AppColor.defaultColor,
          ),
        );
        return ListTile(
          leading: sizedBox,
          title: text,
          subtitle: text2,
          trailing: gestureDetector,
        );
      },
    );
  }
}

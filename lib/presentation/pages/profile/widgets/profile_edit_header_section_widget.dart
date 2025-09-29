import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class EditProfileHeaderWidget extends StatelessWidget {
  const EditProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSizeApp(context).screenWidth,
      child: Observer(
        builder: (_) {
          final currentUser = context.authStore.userInfo;
          return Column(
            children: [
              AvatarBoxShadowWidget(
                height: ResponsiveSizeApp(context).heightPercent(100),
                width: ResponsiveSizeApp(context).widthPercent(100),
                imageUrl: currentUser!['avatar'],
              ),
              HSpacing(20),
              Text('${currentUser['name']}'),
              Text(
                'Facebook',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: FontSizeApp.fontSizeMedium,
                  color: AppColor.mediumGrey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

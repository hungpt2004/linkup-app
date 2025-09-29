import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class HeaderFormWidget extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderFormWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Observer(
      key: ValueKey('form_post_observer'),
      builder: (_) {
        final userInfo = context.authStore.userInfo;
        final avatar = userInfo!['avatar'] as String?;
        final name = userInfo['name'] as String?;

        return ListTile(
          onTap: onTap,
          leading: _leadingListTile(context, avatar),
          title: _titleListTile(name),
          trailing: InkWell(
            child: Icon(
              FluentIcons.share_android_24_regular,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _leadingListTile(BuildContext context, String? avatar) {
    return Container(
      width: ResponsiveSizeApp(context).widthPercent(50),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: MyImageWidget(
          imageUrl:
              (avatar?.isNotEmpty ?? false) ? avatar! : ImagePath.avatarDefault,
        ),
      ),
    );
  }

  Widget _titleListTile(String? name) {
    return Text(
      'What\'s on your mind, ${name ?? 'User'}?',
      style: TextStyle(
        fontSize: FontSizeApp.fontSizeSubMedium,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

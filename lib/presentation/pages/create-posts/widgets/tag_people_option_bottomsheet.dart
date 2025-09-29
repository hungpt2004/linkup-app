import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/selected_user_list_widget.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/suggestion_title_widget.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/friend_tag_section_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/text_input/text_input_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class FormTagPeopleBottomSheet extends StatelessWidget {
  const FormTagPeopleBottomSheet({
    super.key,
    required this.onTap,
    required this.searchController,
  });

  final VoidCallback onTap;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final friendStore = context.friendStore;
    final listFriends = friendStore.friends;
    final tagUserStore = context.tagUserStore;
    return Stack(
      children: [
        PaddingLayout.symmetric(
          horizontal: ResponsiveSizeApp(context).moderateScale(12),
          child: Column(
            children: [
              MyTextInputWidget(
                controller: searchController,
                icon: FluentIcons.search_24_regular,
                hintText: 'Who are you with?',
              ),

              HSpacing(10),

              // SELECTED USERS SECTION
              SelectedUserListWidget(),

              SuggestionTitleWidget(text: 'Suggestions'),

              HSpacing(20),

              // LIST CARD FRIEND TAG
              Expanded(
                child: Observer(
                  builder:
                      (_) => ListView.builder(
                        itemCount: listFriends.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final userIndex = listFriends[index];

                          return FriendTagSectionWidget(
                            userInfo: userIndex,
                            onTapCheckBox:
                                (val) => tagUserStore.toggleChooseUser(
                                  userIndex.id!,
                                  val ?? false,
                                  context,
                                ),
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
        _buildDefaultSession(context),
      ],
    );
  }

  BoxDecoration _defaultBoxDecoration() {
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

  Widget _buildDefaultSession(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: ResponsiveSizeApp(context).screenWidth,
        height: ResponsiveSizeApp(context).heightPercent(120),
        decoration: _defaultBoxDecoration(),
        child: Column(
          children: [
            _defaultCheck(context),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: PaddingSizeApp.paddingSizeSubMedium,
                vertical: PaddingSizeApp.paddingSizeSmall,
              ),
              width: ResponsiveSizeApp(context).screenWidth,
              child: _defaultButtonCheck(
                context,
                () => AppNavigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _defaultCheck(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      PaddingLayout.only(
        left: ResponsiveSizeApp(context).moderateScale(12),
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

Widget _defaultButtonCheck(BuildContext context, VoidCallback onFunction) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onFunction,
    child: Text(
      'Done',
      style: context.textTheme.labelLarge?.copyWith(color: Colors.white),
    ),
  );
}

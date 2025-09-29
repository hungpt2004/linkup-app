import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/container_edit_layout.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/appbar/appbar_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class EditNameProfileScreen extends StatefulWidget {
  const EditNameProfileScreen({super.key});

  @override
  State<EditNameProfileScreen> createState() => _EditNameProfileScreenState();
}

class _EditNameProfileScreenState extends State<EditNameProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();



  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarWidget(
          title: 'Edit Name',
          currentPage: 'edit-name',
          trailingText: 'Done',
          onTrailingPressed: () => AppNavigator.toEditProfielScreen(context),
        ),
      ),
      body: PaddingLayout.only(
        left: ResponsiveSizeApp(context).moderateScale(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Used for 1 profiles',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            HSpacing(20),
            EditProfileContainerLayout(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  PaddingLayout.all(
                    value: 10,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'First name',
                          hintStyle: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColor.mediumGrey,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _dividerBottom(),
                  PaddingLayout.all(
                    value: 10,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Middle name',
                          hintStyle: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColor.mediumGrey,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _dividerBottom(),
                  PaddingLayout.all(
                    value: 10,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          hintStyle: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColor.mediumGrey,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HSpacing(20),
            Wrap(
              children: [
                Text(
                  'If you change your name, you can\'t change it again for 60 days. Dont\'t add any unusual capitalization, punctuation, characters or random words. Learn more',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dividerBottom() {
  return Divider(height: 0.1, color: AppColor.lightGrey);
}
 
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/pages/profile/widgets/profile_edit_header_section_widget.dart';
import 'package:vdiary_internship/presentation/pages/profile/widgets/profile_edit_option_list_widget.dart';
import 'package:vdiary_internship/presentation/pages/profile/widgets/profile_edit_footer_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/appbar/appbar_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarWidget(
          title: 'Edit Profile',
          currentPage: 'edit-profile',
        ),
      ),
      body: Column(
        children: [
          HSpacing(30),
          // HEADER
          EditProfileHeaderWidget(),
          HSpacing(30),
          // CARD BODY
          EditProfileOptionWidget(),
          HSpacing(30),
          // FOOTER
          FooterEditProfileWidget(),
        ],
      ),
    );
  }
}

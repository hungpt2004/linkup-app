import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/pages/profile/widgets/profile_footer_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/container_edit_layout.dart';

class FooterEditProfileWidget extends StatelessWidget {
  const FooterEditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EditProfileContainerLayout(child: CardProfileFooterWidget());
  }
}

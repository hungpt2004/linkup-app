import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class SuggestionTitleWidget extends StatelessWidget {
  const SuggestionTitleWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

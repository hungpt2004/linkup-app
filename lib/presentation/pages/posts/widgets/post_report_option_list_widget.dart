import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';

// RELATIVE IMPORT
import 'post_item_report_widget.dart';

class PostReportOptionList extends StatelessWidget {
  const PostReportOptionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: MockData.listPostReport.length,
            itemBuilder: (context, index) {
              final itemIndex = MockData.listPostReport[index];
              return PostReportSectionWidget(
                title: itemIndex['title'],
                imageUrl: itemIndex['icon'],
                mysubtitle: itemIndex['subtitle'],
                function: () => {},
              );
            },
          ),
        ),
      ],
    );
  }
}

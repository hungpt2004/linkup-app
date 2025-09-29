import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/mock/story_mock_data.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import 'add_story_widget.dart';
import 'story_section_widget.dart';

class StoriesSection extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const StoriesSection({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final groupedStories = StoryMockData.groupedStories;

    return Column(
      children: [
        HSpacing(10),
        SizedBox(
          height: ResponsiveSizeApp(context).heightPercent(200),
          width: ResponsiveSizeApp(context).screenWidth,
          child: ListView.builder(
            key: ValueKey('stories_listview'),
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: groupedStories.length + 1,
            itemBuilder: (context, index) {
              // Item đầu tiên là add story
              if (index == 0) {
                return Container(
                  key: ValueKey('add_story'),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: AddStoryWidget(userInfo: userInfo),
                );
              }

              final storyModel = groupedStories[index - 1];

              return Padding(
                key: ValueKey('story_${storyModel.id}'),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CardStoryWidget(storyModel: storyModel),
              );
            },
          ),
        ),
        HSpacing(10),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/mock/story_mock_data.dart';
import 'package:vdiary_internship/data/models/story/story_model.dart';
import 'package:vdiary_internship/presentation/pages/story/screens/story_viewer_screen.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import '../../../shared/widgets/images/avatar_build_widget.dart';
import '../../../themes/theme/responsive/app_responsive_size.dart';

class CardStoryWidget extends StatelessWidget {
  const CardStoryWidget({super.key, required this.storyModel});

  final StoryModel storyModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Lấy tất cả stories và tìm vị trí của user hiện tại
        final allStories = StoryMockData.stories;
        final groupedStories = StoryMockData.groupedStories;
        final userIndex = groupedStories.indexWhere(
          (story) => story.user.id == storyModel.user.id,
        );

        if (userIndex != -1) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => StoryViewerScreen(
                    allStories: allStories,
                    initialUserIndex: userIndex,
                    initialStoryIndex: 0,
                  ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Container(
        width: ResponsiveSizeApp(context).widthPercent(145),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MyImageWidget(
                imageUrl: storyModel.mediaUrl,
                fit: BoxFit.cover,
                imageWidth: double.infinity,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              left: 3,
              top: 3,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color:
                        storyModel.isViewed
                            ? Colors.grey
                            : context.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: AvatarBoxShadowWidget(
                      width: ResponsiveSizeApp(context).widthPercent(25),
                      height: ResponsiveSizeApp(context).heightPercent(25),
                      imageUrl: storyModel.mediaUrl,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                storyModel.user.name ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

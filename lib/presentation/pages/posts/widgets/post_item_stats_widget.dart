import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/stack_reaction/stack_reaction_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../utils/show_user_reaction_utils.dart';

class PostStatsWidget extends StatefulWidget {
  const PostStatsWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<PostStatsWidget> createState() => _PostStatsWidgetState();
}

class _PostStatsWidgetState extends State<PostStatsWidget> {
  bool showLikeCount = false;

  void _onLikeAreaTap() {
    setState(() {
      showLikeCount = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showLikeCount = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Like
          Observer(
            builder: (_) {
              final int likeCountObservalble =
                  context.postStore.likeCount[widget.post.id] ??
                  widget.post.likeCount;
              final List<LikeModel> likeModels =
                  context.postStore.listLikeUsers[widget.post.id] ?? [];
              final List<UserModel> listUserLikes =
                  likeModels.map((like) => like.user).toList();
              if (!showLikeCount && listUserLikes.isEmpty) {
                return SizedBox.shrink();
              }
              return GestureDetector(
                onTap: _onLikeAreaTap,
                child: SizedBox(
                  child: Row(
                    children: [
                      StackReactionWidget(likeModels: likeModels),
                      Text(
                        showLikeCount
                            ? '$likeCountObservalble'
                            : showReactionUsers(listUserLikes),
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            child: Row(
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Observer(
                        builder: (_) {
                          final postStore = context.postStore;
                          // Ưu tiên dùng comments từ post model (API)
                          // Fallback sang mapPostComments nếu có
                          final mapComments =
                              postStore.mapPostComments[widget.post.id];
                          final commentCount =
                              mapComments?.length ?? widget.post.comments;

                          return Text(
                            '$commentCount comments',
                            style: context.textTheme.bodySmall,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                WSpacing(10),
                SizedBox(
                  child: Row(
                    children: [
                      Text('0 shares', style: context.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

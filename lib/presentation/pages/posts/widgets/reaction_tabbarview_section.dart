import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/controllers/post_controller.dart';
import 'package:vdiary_internship/presentation/pages/posts/utils/show_user_reaction_utils.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';

class ReactionTabViewSection extends StatefulWidget {
  final String postId;
  final String typeReaction;
  const ReactionTabViewSection({
    super.key,
    required this.postId,
    required this.typeReaction,
  });

  @override
  State<ReactionTabViewSection> createState() => _ReactionTabViewSectionState();
}

class _ReactionTabViewSectionState extends State<ReactionTabViewSection> {
  late final PostController postController;
  late Future<List<LikeModel>> _futureData;

  @override
  void didChangeDependencies() {
    postController = PostController(postStoreRef: context.postStore);
    _futureData = fetchData(widget.postId, widget.typeReaction);
    super.didChangeDependencies();
  }

  Future<List<LikeModel>> fetchData(String postId, String typeReact) async {
    await postController.findReactionByType(postId, typeReact);
    // Lấy từ mobx store
    final postStore = context.postStore;
    final key = '$postId-$typeReact';
    return postStore.mapReactionByType[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LikeModel>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text('Không có dữ liệu reaction'));
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final like = data[index];
            return ListTile(
              leading: Stack(
                children: [
                  AvatarBoxShadowWidget(
                    imageUrl: like.user.avatarUrl ?? '',
                    width: 40,
                    height: 40,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      convertStringToSVG(like.typeReact),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ],
              ),
              title: Text(like.user.name ?? ''),
            );
          },
        );
      },
    );
  }
}

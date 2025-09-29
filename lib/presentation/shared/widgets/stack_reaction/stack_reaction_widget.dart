import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/utils/show_user_reaction_utils.dart';

class StackReactionWidget extends StatelessWidget {
  const StackReactionWidget({super.key, required this.likeModels});

  final List<LikeModel>? likeModels;

  @override
  Widget build(BuildContext context) {
    // Lấy tối đa 2 typeReact khác nhau
    final uniqueTypes = <String>[];
    final icons = <Widget>[];
    if (likeModels != null) {
      for (var like in likeModels!) {
        if (!uniqueTypes.contains(like.typeReact)) {
          uniqueTypes.add(like.typeReact);
          icons.add(
            SvgPicture.asset(
              showReactionImage(like.typeReact, [like]),
              width: 16,
              height: 16,
            ),
          );
          if (uniqueTypes.length == 2) break;
        }
      }
    }
    if (icons.isEmpty) {
      icons.add(
        SvgPicture.asset(ImagePath.likeReactionSVG, width: 16, height: 16),
      );
      icons.add(
        SvgPicture.asset(ImagePath.loveReactionSVG, width: 16, height: 16),
      );
    }
    return SizedBox(
      width: icons.length <= 1 ? 22 : 30,
      height: 16,
      child: Stack(
        children: [
          if (icons.isNotEmpty) Positioned(left: 0, child: icons[0]),
          if (icons.length > 1) Positioned(left: 10, child: icons[1]),
        ],
      ),
    );
  }
}

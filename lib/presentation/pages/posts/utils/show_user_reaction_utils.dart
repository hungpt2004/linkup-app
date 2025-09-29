import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';

String showReactionUsers(List<UserModel> users) {
  switch (users.length) {
    case 0:
      return '0';
    case 1:
      return '${users.last.name}';
    default:
      return '${users.last.name} + ${(users.length - 1)}';
  }
}

String showReactionImage(String typeReact, List<LikeModel> listUsersLike) {
  switch (typeReact) {
    case 'like':
      return ImagePath.likeReactionSVG;
    case 'care':
      return ImagePath.careReactionSVG;
    case 'love':
      return ImagePath.loveReactionSVG;
    case 'haha':
      return ImagePath.hahaReactionSVG;
    case 'wow':
      return ImagePath.wowReactionSVG;
    case 'sad':
      return ImagePath.sadReactionSVG;
    case 'angry':
      return ImagePath.angryReactionSVG;
    default:
      return '';
  }
}

String convertStringToSVG(String typeReact) {
  switch (typeReact) {
    case 'like':
      return ImagePath.likeReactionSVG;
    case 'care':
      return ImagePath.careReactionSVG;
    case 'love':
      return ImagePath.loveReactionSVG;
    case 'haha':
      return ImagePath.hahaReactionSVG;
    case 'wow':
      return ImagePath.wowReactionSVG;
    case 'sad':
      return ImagePath.sadReactionSVG;
    case 'angry':
      return ImagePath.angryReactionSVG;
    default:
      return '';
  }
}

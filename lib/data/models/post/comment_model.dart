import '../user/user_model.dart';
import 'package:comment_tree/data/comment.dart';

// Custom lại class Comment để thêm trường id
class CustomComment extends Comment {
  final String? id;
  CustomComment({
    this.id,
    super.avatar,
    super.userName,
    super.content,
    super.replies,
  });
}

class CommentModel {
  String? id;
  String? text;
  UserModel? author;
  String? postId;
  String? parentId;
  List<String>? mentions;
  int? likes;
  List<CommentModel>? replies; // Đã sửa: giờ là một danh sách
  DateTime? createdAt;
  DateTime? updatedAt;
  int? childCommentCount; // Thêm trường này từ JSON
  bool? isFlaggedBadword;
  String? warningMessage;

  CommentModel({
    this.id,
    this.text,
    this.author,
    this.postId,
    this.parentId,
    this.mentions,
    this.likes,
    this.replies,
    this.createdAt,
    this.updatedAt,
    this.childCommentCount,
    this.isFlaggedBadword,
    this.warningMessage,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    List<CommentModel>? repliesList;
    if (json['replies'] is List) {
      repliesList =
          (json['replies'] as List)
              .map(
                (item) => CommentModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
    }

    return CommentModel(
      id: json['_id'] as String?,
      text: json['text'] as String?,
      author:
          json['author'] != null
              ? UserModel.fromJson(json['author'] as Map<String, dynamic>)
              : null,
      postId: json['postId'] as String?,
      parentId: json['parentId'] as String?,
      mentions:
          (json['mentions'] as List?)?.map((item) => item.toString()).toList(),
      likes: _parseLikes(json['likes']),
      replies: repliesList,
      createdAt: _parseDateTime(json['createdAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
      childCommentCount: json['childCommentCount'] as int?,
      isFlaggedBadword: json['isFlaggedBadword'] as bool?,
      warningMessage: json['warningMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'text': text,
      'author': author?.toJson(),
      'postId': postId,
      'parentId': parentId,
      'mentions': mentions,
      'likes': likes,
      'replies': replies?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'childCommentCount': childCommentCount,
      'isFlaggedBadword': isFlaggedBadword,
      'warningMessage': warningMessage,
    };
  }
}

// Hàm helper để parse DateTime và likes
DateTime? _parseDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return null;
  }
}

int? _parseLikes(dynamic likesData) {
  if (likesData == null) return 0;
  if (likesData is int) return likesData;
  if (likesData is List) return likesData.length;
  return 0;
}

CustomComment mapToComment(CommentModel customComment) {
  return CustomComment(
    id: customComment.id,
    avatar: customComment.author?.avatarUrl,
    userName: customComment.author?.name,
    content: customComment.text,
    replies: customComment.replies?.map((r) => mapToComment(r)).toList(),
  );
}

// Hàm xây dựng cây bình luận từ danh sách phẳng
List<CommentModel> buildCommentTree(List<CommentModel> comments) {
  final Map<String, CommentModel> commentMap = {
    for (var comment in comments) comment.id!: comment,
  };
  final List<CommentModel> rootComments = [];

  for (var comment in comments) {
    if (comment.parentId == null) {
      rootComments.add(comment);
    } else {
      final parentComment = commentMap[comment.parentId];
      if (parentComment != null) {
        // Gán danh sách trống nếu chưa có
        parentComment.replies ??= [];
        parentComment.replies!.add(comment);
      }
    }
  }
  return rootComments;
}

bool isValidComment(CommentModel comment) {
  return comment.id != null &&
      comment.author != null &&
      comment.author!.id != null &&
      comment.text != null;
}

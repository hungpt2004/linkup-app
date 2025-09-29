import 'package:hive/hive.dart';
import 'package:vdiary_internship/data/models/user/hive/user_model_hive.dart';
import 'link_model_hive.dart';
import 'mention_model_hive.dart';
import 'hashtag_model_hive.dart';
import 'like_model_hive.dart';

part 'post_model_hive.g.dart';

@HiveType(typeId: 0)
class PostModelHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String caption;

  @HiveField(2)
  List<String> images;

  @HiveField(3)
  List<String> videos;

  @HiveField(4)
  List<LinkModelHive> links;

  @HiveField(5)
  String author;

  @HiveField(6)
  List<HashtagModelHive> hashtags;

  @HiveField(7)
  List<MentionModelHive> mentions;

  @HiveField(8)
  List<LikeModelHive> listUsers;

  @HiveField(9)
  int likeCount;

  @HiveField(10)
  String privacy;

  @HiveField(11)
  int comments;

  @HiveField(12)
  UserModelHive user;

  @HiveField(13)
  DateTime? createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  PostModelHive({
    required this.id,
    required this.caption,
    required this.images,
    required this.videos,
    required this.links,
    required this.author,
    required this.hashtags,
    required this.mentions,
    required this.listUsers,
    required this.likeCount,
    required this.privacy,
    required this.comments,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });
}

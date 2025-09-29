import 'package:flutter/material.dart';

// RELATIVE IMPORT
import 'hashtag_model.dart';
import 'like_model.dart';
import 'link_model.dart';
import 'mention_model.dart';
import '../user/user_model.dart';

class PostModel {
  final String id;
  final String caption;
  final List<String> images;
  final List<String> videos;
  final List<LinkModel> links;
  final String author;
  final List<HashtagModel> hashtags;
  final List<MentionModel> mentions;
  final List<LikeModel> listUsers;
  final int likeCount;
  final String privacy;
  final int comments;
  final UserModel user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostModel({
    required this.id,
    required this.caption,
    required this.images,
    required this.videos,
    required this.links,
    required this.author,
    required this.hashtags,
    required this.mentions,
    required this.privacy,
    required this.comments,
    required this.user,
    this.listUsers = const [],
    this.likeCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] as String,
      caption: json['caption'] as String,
      images: List<String>.from(json['images'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      links:
          (json['links'] as List<dynamic>? ?? [])
              .map((e) => LinkModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      author:
          json['author'] is String
              ? json['author'] as String
              : (json['author'] as Map<String, dynamic>)['_id'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => HashtagModel.fromJson(e))
              .toList() ??
          [],
      mentions:
          (json['mentions'] as List<dynamic>?)
              ?.map((e) => MentionModel.fromJson(e))
              .toList() ??
          [],
      listUsers:
          (json['likes'] as List<dynamic>?)
              ?.map((e) => LikeModel.fromJson(e))
              .toList() ??
          [],
      likeCount: json['likeCount'] as int? ?? 0,
      privacy: json['privacy'] as String,
      comments: json['comments'] as int? ?? 0,
      user:
          json['user'] != null
              ? UserModel.fromJson(json['user'])
              : (json['author'] is Map<String, dynamic>
                  ? UserModel.fromJson(json['author'])
                  : UserModel.fromJson({
                    '_id': json['author'],
                    'name': 'User',
                    'email': 'user@example.com',
                    'avatar': '',
                    'verified': false,
                    'role': 'user',
                  })),
      createdAt: _parseDateTime(json['createdAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'caption': caption,
    'images': images,
    'videos': videos,
    'links': links.map((e) => e.toJson()).toList(),
    'author': author,
    'hashtags': hashtags.map((e) => e.toJson()).toList(),
    'mentions': mentions.map((e) => e.toJson()).toList(),
    'privacy': privacy,
    'comments': comments,
    'user': user.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }
}

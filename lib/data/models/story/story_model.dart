import '../user/user_model.dart';

class StoryModel {
  final String id;
  final UserModel user;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final String? caption;
  final DateTime createdAt;
  final bool isViewed;

  StoryModel({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    required this.createdAt,
    required this.isViewed,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',
      caption: json['caption'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isViewed: json['isViewed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
      'isViewed': isViewed,
    };
  }

  StoryModel copyWith({
    String? id,
    UserModel? user,
    String? mediaUrl,
    String? mediaType,
    String? caption,
    DateTime? createdAt,
    bool? isViewed,
  }) {
    return StoryModel(
      id: id ?? this.id,
      user: user ?? this.user,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}

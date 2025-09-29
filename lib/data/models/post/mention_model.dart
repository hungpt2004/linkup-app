class MentionModel {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  MentionModel({
    required this.id,
    required this.name, // ← Required
    required this.email,
    this.avatar,
  });

  factory MentionModel.fromJson(Map<String, dynamic> json) {
    return MentionModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
  };

  String get displayName => name.isNotEmpty ? name : email;
  String get mentionTag => '@$name';
}

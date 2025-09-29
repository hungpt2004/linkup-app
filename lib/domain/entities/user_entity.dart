import 'package:vdiary_internship/data/models/user/user_model.dart';

class UserEntity {
  final String id;
  final String username;
  final String avatar;
  final String fullname;

  const UserEntity({
    required this.id,
    required this.username,
    required this.avatar,
    required this.fullname,
  });

  // Factory constructor to create UserEntity from UserModel
  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id ?? '',
      username:
          model.email?.split('@').first ?? '', // Use email prefix as username
      avatar: model.avatarUrl ?? '',
      fullname: model.name ?? '',
    );
  }

  // Convert to UserModel (if needed for data layer operations)
  UserModel toModel() {
    return UserModel(
      id: id,
      email: '$username@example.com', // Reconstruct email if needed
      name: fullname,
      avatarUrl: avatar,
    );
  }

  // Convert to Map for Firebase serialization
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'avatar': avatar,
      'fullname': fullname,
    };
  }

  // Factory constructor to create UserEntity from Map
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? '',
      fullname: map['fullname'] ?? '',
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.username == username &&
        other.avatar == avatar &&
        other.fullname == fullname;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        avatar.hashCode ^
        fullname.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, avatar: $avatar, fullname: $fullname)';
  }

  // Copy with method for immutable updates
  UserEntity copyWith({
    String? id,
    String? username,
    String? avatar,
    String? fullname,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      fullname: fullname ?? this.fullname,
    );
  }

  // Empty user entity for fallback cases
  static UserEntity empty() {
    return const UserEntity(id: '', username: '', avatar: '', fullname: '');
  }
}

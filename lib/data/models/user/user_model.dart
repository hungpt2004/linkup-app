import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';

enum UserRole { admin, user }

// Model thì không chắc giống chính xác response.data -> chỉ là 1 kiểu để định nghĩa dữ liệu trả về ra API

class UserModel {
  String? id;
  String? email;
  String? name;
  bool verified;
  UserRole role;
  String? avatarUrl;
  int numberFriends;
  String? coverImageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.verified = false,
    this.role = UserRole.user,
    this.avatarUrl,
    this.numberFriends = 0,
    this.coverImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      verified: json['verified'] as bool? ?? false,
      role: _parseRole(json['role'] as String?),
      avatarUrl: _parseAvatar(json['avatar'] as String?),
      numberFriends: json['numberFriends'] as int? ?? 0,
      coverImageUrl:
          json['background'] as String? ?? ImagePath.backgroundDefault,
      createdAt: _parseDateTime(json['createdAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  static String _parseAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return ImagePath.avatarDefault;
    }
    return avatar;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'verified': verified,
    'role': role.name,
    'avatar': avatarUrl,
    'numberFriends': numberFriends,
    'coverImageUrl': coverImageUrl,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

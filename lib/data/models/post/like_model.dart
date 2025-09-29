// RELATIVE IMPORT
import '../user/user_model.dart';

class LikeModel {
  final String id;
  final String typeReact;
  final UserModel user;

  LikeModel({required this.id, required this.typeReact, required this.user});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json['userId'];
    return LikeModel(
      id: json['_id'] as String,
      typeReact: json['typeReact'] as String,
      user: UserModel.fromJson(userJson),
    );
  }
}

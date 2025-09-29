import 'package:hive/hive.dart';

part 'user_model_hive.g.dart';

@HiveType(typeId: 1)
enum UserRoleHive {
  @HiveField(0)
  admin,
  @HiveField(1)
  user,
}

@HiveType(typeId: 2)
class UserModelHive extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool verified;

  @HiveField(4)
  UserRoleHive role;

  @HiveField(5)
  String? avatarUrl;

  @HiveField(6)
  int numberFriends;

  @HiveField(7)
  String? coverImageUrl;

  @HiveField(8)
  DateTime? createdAt;

  @HiveField(9)
  DateTime? updatedAt;

  UserModelHive({
    this.id,
    this.email,
    this.name,
    this.verified = false,
    this.role = UserRoleHive.user,
    this.avatarUrl,
    this.numberFriends = 0,
    this.coverImageUrl,
    this.createdAt,
    this.updatedAt,
  });
}

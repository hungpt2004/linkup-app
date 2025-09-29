import 'package:hive/hive.dart';
import 'package:vdiary_internship/data/models/user/hive/user_model_hive.dart';

part 'like_model_hive.g.dart';

@HiveType(typeId: 3)
class LikeModelHive {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String typeReact;
  
  @HiveField(2)
  final UserModelHive user;

  LikeModelHive({
    required this.id, 
    required this.typeReact, 
    required this.user
  });
}
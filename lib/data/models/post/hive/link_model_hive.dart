import 'package:hive/hive.dart';

part 'link_model_hive.g.dart';

@HiveType(typeId: 4)
class LinkModelHive {
  @HiveField(0)
  final String url;
  
  @HiveField(1)
  final String? title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final String? image;

  LinkModelHive({
    required this.url, 
    this.title, 
    this.description, 
    this.image
  });
}
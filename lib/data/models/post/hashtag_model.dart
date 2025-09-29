class HashtagModel {
  final String id;
  final String name;

  HashtagModel({required this.id, required this.name});

  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

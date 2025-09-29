class LinkModel {
  final String url;
  final String? title;
  final String? description;
  final String? image;

  LinkModel({required this.url, this.title, this.description, this.image});

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (image != null) 'image': image,
  };
}

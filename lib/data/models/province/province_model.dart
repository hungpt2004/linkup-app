class ProvinceModel {
  int code;
  String name;
  String? nameEn;
  String? fullName;
  String? fullNameEn;
  String codeName;

  ProvinceModel({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    required this.codeName,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      code: json['code'],
      name: json['name'],
      codeName: json['codename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'code_name': codeName};
  }
}

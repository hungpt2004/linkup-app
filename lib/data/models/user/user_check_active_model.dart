class UserCheckActiveModel {
  final String state;
  final int lastChanged;

  UserCheckActiveModel({required this.state, required this.lastChanged});

  factory UserCheckActiveModel.fromJson(Map<String, dynamic> json) {
    return UserCheckActiveModel(
      state: json['state'],
      lastChanged: json['last_changed'],
    );
  }
}

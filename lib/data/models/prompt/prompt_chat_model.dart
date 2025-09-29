class ChatModel {
  String? id;
  final String sendMessage;
  final String? responseMessage;
  final String? type;
  DateTime? createdAt;

  ChatModel({
    this.id,
    required this.sendMessage,
    required this.responseMessage,
    this.type,
    this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      sendMessage: json['message'],
      responseMessage: json['response'],
      type: json['type'],
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'message': sendMessage,
    'response': responseMessage,
    'type': type,
  };

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}

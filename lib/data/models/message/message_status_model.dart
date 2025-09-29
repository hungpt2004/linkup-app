class MessageStatus {
  final List<Map<String, dynamic>> deliveredTo;
  final List<Map<String, dynamic>> readBy;

  MessageStatus({
    required this.deliveredTo,
    required this.readBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "deliveredTo": deliveredTo,
      "readBy": readBy,
    };
  }

  factory MessageStatus.fromMap(Map<String, dynamic> map) {
    return MessageStatus(
      deliveredTo: List<Map<String, dynamic>>.from(map["deliveredTo"] ?? []),
      readBy: List<Map<String, dynamic>>.from(map["readBy"] ?? []),
    );
  }
}
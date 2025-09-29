import 'package:flutter/cupertino.dart';

// RELATIVE IMPORT
import '../user/user_model.dart';

class FriendModel {
  String? id;
  String requesterId; //ID người gửi
  UserModel? requester;
  String recipientId;
  UserModel? recipient;
  FriendType? type;
  StatusType? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  FriendModel({
    this.id,
    required this.requesterId,
    this.requester,
    required this.recipientId,
    this.recipient,
    this.type = FriendType.friendRequest,
    this.status = StatusType.pending,
    this.createdAt,
    this.updatedAt,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    // Requester là String hoặc Map (Nếu populate)
    // API chỉ populate người gửi
    final populateRequester = json['requester'];
    String? requesId;
    UserModel? requesUser;
    if (populateRequester is String) {
      requesId = populateRequester;
    } else if (populateRequester is Map<String, dynamic>) {
      requesUser = UserModel.fromJson(populateRequester);
      requesId = populateRequester['_id'] as String?;
    }

    final populateRecipient = json['recipient'];
    String? recipId;
    UserModel? recipUser;
    if (populateRecipient is String) {
      recipId = populateRecipient;
    } else if (populateRecipient is Map<String, dynamic>) {
      recipUser = UserModel.fromJson(populateRecipient);
      recipId = populateRecipient['_id'] as String?;
    }

    return FriendModel(
      id: json['_id'], //ObjectID
      requesterId: requesId ?? 'No have ID',
      requester: requesUser,
      recipientId: recipId ?? 'No have ID',
      recipient: recipUser,
      type: FriendType.fromString(json['type']),
      status: StatusType.fromString(json['status']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {};

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }
}

enum FriendType {
  follow,
  friendRequest;

  /// Convert từ string sang enum
  static FriendType? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'follow':
        return FriendType.follow;
      case 'friend_request':
        return FriendType.friendRequest;
      default:
        return null;
    }
  }

  /// Convert enum sang string
  String toApiString() {
    switch (this) {
      case FriendType.follow:
        return 'follow';
      case FriendType.friendRequest:
        return 'friend_request';
    }
  }
}

/// Enum định nghĩa trạng thái của friend request
enum StatusType {
  pending,
  accepted,
  rejected,
  following;

  /// Convert từ string sang enum
  static StatusType? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return StatusType.pending;
      case 'accepted':
        return StatusType.accepted;
      case 'rejected':
        return StatusType.rejected;
      case 'following':
        return StatusType.following;
      default:
        return null;
    }
  }

  /// Convert enum sang string
  String toApiString() {
    switch (this) {
      case StatusType.pending:
        return 'pending';
      case StatusType.accepted:
        return 'accepted';
      case StatusType.rejected:
        return 'rejected';
      case StatusType.following:
        return 'following';
    }
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/secret_key.dart';
import 'package:vdiary_internship/data/models/message/chat_member_model.dart';
import 'package:vdiary_internship/data/models/message/message_model.dart';
import 'package:vdiary_internship/data/services/upload_image_supabase_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/message_encrypt_service.dart';
import 'package:vdiary_internship/presentation/shared/store/firebase-database-provider/firebase_store_singleton.dart';
import 'package:vdiary_internship/presentation/shared/store/supabase-provider/supabase_client_singleton.dart';

class ChatFirebaseService {
  final _db = FirebaseFirestoreProvider().instance;
  final supabase = SupabaseSingleton().client;
  final String bucketName = SecretConstantValue().supabaseCloud;
  UploadSupabaseService get uploadSupabaseService =>
      UploadSupabaseService(supabase, bucketName);

  // Tạo chat room
  Future<String> createChatRoom({
    required String type, // private || group
    String? name,
    String? avatarGroup = ImagePath.avatarDefault,
    required List<ChatMember> members,
    required String createBy,
  }) async {
    // Kiểm tra private
    if (type == 'private' && members.length != 2) {
      throw Exception('Private chat must have exactly 2 members');
    }

    final membersIds = members.map((item) => item.userId).toList();

    // 1. Check nếu là private
    if (type == 'private') {
      final querySnapShot =
          await _db
              .collection("chat_rooms")
              .where("type", isEqualTo: "private")
              .where("membersIds", arrayContains: membersIds[0])
              .get();

      for (var doc in querySnapShot.docs) {
        final ids = List<String>.from(doc.data()['membersIds']);
        if (ids.contains(membersIds[1])) {
          return doc.id;
        }
      }
    }

    // Nếu chưa tồn tại, tạo mới
    final doc = _db.collection("chat_rooms").doc();
    final now = DateTime.now();

    await doc.set({
      "roomId": doc.id,
      "type": type,
      "members": members.map((m) => m.toMap()).toList(),
      "membersIds": membersIds,
      "name": name,
      "avatarUrl": avatarGroup,
      "createdAt": now.toIso8601String(),
      "createdBy": createBy,
      "lastMessage": null,
    });

    return doc.id;
  }

  // Kiểm tra xem trong readby có chưa
  Future<bool> checkContainReadby({
    required String userId,
    required List<String> readBy,
  }) async {
    return readBy.contains(userId);
  }

  // Update readby with user id
  Future<void> updateReadBy(
    List<String>? userIds, {
    required String currentUserId,
    required String currentUserAvatar,
    required String otherUserId,
    required String roomId,
    required String messageId,
  }) async {
    // Nếu là chủ tin nhắn thì không cần update
    if (currentUserId == otherUserId) return;

    final msgRef = _db
        .collection("chat_rooms")
        .doc(roomId)
        .collection("messages")
        .doc(messageId);

    // Lấy message hiện tại
    final msgSnap = await msgRef.get();
    if (!msgSnap.exists) return;

    final data = msgSnap.data();
    if (data == null) return;

    // Lấy danh sách readBy hiện tại
    List<Map<String, dynamic>> readBy = [];
    if (data['status'] != null && data['status']['readBy'] != null) {
      readBy = List<Map<String, dynamic>>.from(data['status']['readBy']);
    }

    // Kiểm tra đã có userId chưa
    final alreadyRead = readBy.any((item) => item['userId'] == currentUserId);

    if (!alreadyRead) {
      readBy.add({
        'userId': currentUserId,
        'userAvatar': currentUserAvatar,
        'readAt': DateTime.now().millisecondsSinceEpoch,
      });

      await msgRef.update({'status.readBy': readBy});
    }
  }

  // Kiểm tra phòng tồn tại hay chưa
  Future<bool> existRoom({required List<String> membersIds}) async {
    if (membersIds.length != 2) {
      throw Exception('Private chat must have exactly 2 members');
    }
    final querySnapShot =
        await _db
            .collection("chat_rooms")
            .where("type", isEqualTo: "private")
            .where("membersIds", arrayContains: membersIds[0])
            .get();

    // Chỉ cần kiểm tra có doc nào chứa cả 2 user
    return querySnapShot.docs.any((doc) {
      final ids = List<String>.from(doc.data()['membersIds']);
      return ids.contains(membersIds[1]);
    });
  }

  // Send Message
  Future<void> sendMessage({
    required String roomId,
    required Message message,
  }) async {
    final msgRef = _db.collection("chat_rooms/$roomId/messages").doc();
    final newMessage = Message(
      messageId: msgRef.id,
      senderId: message.senderId,
      type: message.type,
      text: message.text != null ? encryptMessage(message.text ?? '') : null,
      images: message.images,
      createdAt: Timestamp.now(),
      status: message.status,
    );

    // message.images?.add(
    //   'https://i.pinimg.com/736x/2a/e0/dd/2ae0dd92ab319c1c345b20272f603330.jpg',
    // );

    // Check image
    // If images.isNotEmpty => public to supabase and get url
    if (message.images != null) {
      if (message.images?.length == 1) {
        debugPrint('Đang upload 1 ảnh');
        var singleImage = await uploadSupabaseService.uploadFile(
          File(message.images?.first ?? ''),
          path: 'media/$roomId',
        );
        if (singleImage != null) message.images?[0] == singleImage;
      }
    }

    await msgRef.set(newMessage.toMap());
    await _db.collection("chat_rooms").doc(roomId).update({
      "lastMessage": {
        "text": message.text ?? (message.images ?? "📷 Image"),
        "messageId": newMessage.messageId,
        "senderId": message.senderId,
        "createdAt": Timestamp.now(),
      },
    });
  }

  Future<void> deleteMessage({
    required String messageId,
    required String roomId,
    required String userId,
  }) async {
    final messageRef = _db
        .collection("chat_rooms/$roomId/messages")
        .doc(messageId);
    final roomRef = _db.collection("chat_rooms").doc(roomId);
    // ignore: unnecessary_null_comparison
    if (messageRef == null || roomRef == null) return;

    // Update message + soft deleted
    await messageRef.update({
      "isDeleted": true,
      "text": encryptMessage("This message was deleted"),
    });

    // Update the last message
    await roomRef.update({
      "lastMessage": {
        "text": encryptMessage("This message was deleted"),
        "senderId": userId,
      },
    });
  }

  // Get Message by room id
  Stream<List<Message>> getMessagesStream(String roomId) {
    return _db
        .collection("chat_rooms/$roomId/messages")
        .orderBy("createdAt", descending: false)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return [];
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Message.fromMap(data);
          }).toList();
        });
  }

  Future<String?> getChatRoomIdForPrivate(
    String currentUserId,
    String otherUserId,
  ) async {
    final querySnapShot =
        await _db
            .collection("chat_rooms")
            .where("type", isEqualTo: "private")
            .where("membersIds", arrayContains: currentUserId)
            .get();
    for (var doc in querySnapShot.docs) {
      final ids = List<String>.from(doc.data()['membersIds']);
      if (ids.contains(otherUserId)) {
        return doc.id;
      }
    }
    return null;
  }
}

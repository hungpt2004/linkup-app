import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/prompt/prompt_chat_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat_service.dart';
import 'package:vdiary_internship/presentation/shared/store/firebase-database-provider/firebase_store_singleton.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ChatService _chatService = ChatService();

  @observable
  bool isLoading = false;

  @observable
  String? replyingValue = '';

  @observable
  String? replyToMessageId;

  @observable
  String? replyToUserId;

  @observable
  String? replyToUserName;

  @observable
  String? replyToMessageText;

  @observable
  bool isRefreshing = false;

  @observable
  String? errorMessage;

  @observable
  bool isLoadMore = false;

  @observable
  bool hasMorePosts = true;

  @observable
  int currentPage = 1;

  @observable
  bool isResponseLoading = false;

  @action
  void setReplyingValue(String text) => replyingValue = text;

  @action
  void setReplyTarget({
    required String messageId,
    required String userId,
    required String userName,
    required String messageText,
  }) {
    replyToMessageId = messageId;
    replyToUserId = userId;
    replyToUserName = userName;
    replyToMessageText = messageText;
  }

  @action
  void clearReplyTarget() {
    replyToMessageId = null;
    replyToUserId = null;
    replyToUserName = null;
    replyToMessageText = null;
    replyingValue = '';
  }

  @computed
  bool get isReplying => replyToMessageId != null;

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setRefreshing(bool value) {
    isRefreshing = value;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void setIsResponseLoading(bool value) {
    isResponseLoading = value;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void clear() {
    isLoading = false;
    errorMessage = null;
    clearReplyTarget(); // Clear reply state when clearing store
  }

  @action
  void clearChatImageArray() => chatImageArray.clear();

  @action
  void removeImage(int index) => chatImageArray.removeAt(index);

  @action
  void addImageIntoArray(String imagePath) {
    chatImageArray.add(imagePath);
  }

  @action
  void addArrayImageIntoArray(List<String> imagePaths) {
    chatImageArray.addAll(imagePaths);
  }

  @observable
  ObservableList<String> chatImageArray = ObservableList<String>();

  @observable
  ObservableList<ChatModel> listChatBoxMessages = ObservableList<ChatModel>();

  @observable
  ObservableList<ChatModel> listChatBoxMessagesCache =
      ObservableList<ChatModel>();

  @observable
  ObservableMap<String, String> postIdsAndContentMap =
      ObservableMap<String, String>();

  // Message read status management
  @observable
  ObservableMap<String, bool> messageReadStatus = ObservableMap<String, bool>();

  // Last message text management
  @observable
  ObservableMap<String, String> lastMessageTexts =
      ObservableMap<String, String>();

  @action
  void updateReadStatus(String messageId, bool isRead) {
    messageReadStatus[messageId] = isRead;
  }

  @action
  void updateLastMessageText(String roomId, String text) {
    lastMessageTexts[roomId] = text;
  }

  @action
  void clearReadStatus() {
    messageReadStatus.clear();
  }

  @action
  void clearLastMessageTexts() {
    lastMessageTexts.clear();
  }

  bool getReadStatus(String messageId) {
    return messageReadStatus[messageId] ?? false;
  }

  String getLastMessageText(String roomId) {
    return lastMessageTexts[roomId] ?? '';
  }

  // Reply getter methods
  String get replyTargetUserName => replyToUserName ?? '';
  String get replyTargetMessageText => replyToMessageText ?? '';
  String get replyTargetUserId => replyToUserId ?? '';
  String get replyTargetMessageId => replyToMessageId ?? '';

  @action
  bool shouldShowUnreadIndicator({
    required String messageId,
    required String senderId,
    required String currentUserId,
    required List<dynamic>? readByList,
  }) {
    // Nếu là tin nhắn của chính user thì không hiển thị unread indicator
    if (senderId == currentUserId) {
      return false;
    }

    // Kiểm tra trong readBy list
    if (readByList is List && readByList.isNotEmpty) {
      final isRead = readByList.any(
        (item) => item is Map && item['userId'] == currentUserId,
      );
      updateReadStatus(messageId, isRead);
      return !isRead; // Hiển thị indicator nếu chưa đọc
    }

    return true; // Hiển thị indicator mặc định nếu không có data
  }

  // Send request summary text
  @action
  Future<bool> sendRequestSummaryText(String postId, String content) async {
    try {
      setLoading(true);
      var response = await _chatService.sendRequestSummaryText(content);
      // response -> data
      if (response['data'] != null) {
        final summaryData = response['data'];
        final summaryReponse = summaryData['response'] ?? '';
        debugPrint('$summaryReponse');
        postIdsAndContentMap[postId] = summaryReponse;
        return true;
      } else {
        return false;
      }
    } catch (error) {
      setError(error.toString());
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 500),
        () => setLoading(false),
      );
    }
  }

  // Send message chat box
  @action
  Future<bool> sendChatBoxMessage(String content) async {
    try {
      setLoading(true);

      final userMessage = ChatModel(
        id: DateTime.now().toString(),
        createdAt: DateTime.now(),
        sendMessage: content,
        responseMessage: null,
      );

      // Insert vào list messages
      listChatBoxMessages.insert(0, userMessage);

      // Gửi API -> nếu success -> xóa tỏng list
      var response = await _chatService.sendMessageChat(content);

      if (response['success'] == true) {
        // 4. Nhận phản hồi từ server và tạo ChatModel chính thức
        final serverResponse = ChatModel.fromJson(response['data']);

        // 5. Tìm và thay thế tin nhắn tạm thời bằng tin nhắn chính thức
        final index = listChatBoxMessages.indexWhere(
          (chat) => chat.id == userMessage.id,
        );

        if (index != -1) {
          listChatBoxMessages[index] = serverResponse;
        } else {
          listChatBoxMessages.insert(0, serverResponse);
        }

        return true;
      } else {
        setError(response['message'] ?? 'Gửi tin nhắn thất bại.');
        listChatBoxMessages.removeWhere((chat) => chat.id == userMessage.id);
        return false;
      }
    } catch (error) {
      setError(error.toString());
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 400),
        () => setLoading(false),
      );
    }
  }

  // Lấy lịch sử chat box
  @action
  Future<void> findHistoryChatBoxMessage({bool refresh = false}) async {
    try {
      if (refresh) {
        setRefreshing(true);
        currentPage = 1;
        hasMorePosts = true;
        listChatBoxMessages.clear();
      } else {
        setLoading(true);
      }

      clearError();

      var response = await _chatService.findHistoryChatBox(
        page: currentPage,
        limit: 10,
      );

      if (response['data'] != null) {
        final List<dynamic> chatBoxMessageData = response['data'];
        final List<ChatModel> convertChatMessages =
            chatBoxMessageData
                .map((chatBoxJson) => ChatModel.fromJson(chatBoxJson))
                .toList();
        listChatBoxMessages.addAll(convertChatMessages);
      }
    } catch (e) {
      setError('Lỗi khi tải bài viết: ${e.toString()}');
    } finally {
      if (refresh) {
        await Future.delayed(Duration(milliseconds: 800));
      }
      setLoading(false);
      setRefreshing(false);
    }
  }

  // Kiểm tra phòng còn tồn tại
  @action
  Future<bool> checkExistRoom({required List<String> membersIds}) async {
    try {
      final db = FirebaseFirestoreProvider().instance;
      setLoading(true);
      if (membersIds.length != 2) {
        throw Exception('Private chat must have exactly 2 members');
      }
      final querySnapShot =
          await db
              .collection("chat_rooms")
              .where("type", isEqualTo: "private")
              .where("membersIds", arrayContains: membersIds[0])
              .get();

      // Chỉ cần kiểm tra có doc nào chứa cả 2 user
      return querySnapShot.docs.any((doc) {
        final ids = List<String>.from(doc.data()['membersIds']);
        return ids.contains(membersIds[1]);
      });
    } catch (error) {
      throw FirebaseException(plugin: error.toString());
    } finally {
      await Future.delayed(
        Duration(milliseconds: 500),
        () => setLoading(false),
      );
    }
  }

  @action
  Future<void> initialize() async {
    await Future.wait([findHistoryChatBoxMessage(refresh: true)]);
  }

  @action
  void clearDataSummaryMap() {
    postIdsAndContentMap.clear();
  }
}

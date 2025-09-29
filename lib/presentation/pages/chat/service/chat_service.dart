import 'package:vdiary_internship/data/repositories_impl/chat_repository_impl.dart';

class ChatService {
  final ChatRepositoryImpl _chatRepositoryImpl = ChatRepositoryImpl();

  Future<Map<String, dynamic>> sendMessageChat(String content) async {
    try {
      var response = await _chatRepositoryImpl.createChatBoxMessage(content);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> findHistoryChatBox({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await _chatRepositoryImpl.findChatBoxHistory(
        page: page,
        limit: limit,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendRequestSummaryText(String content) async {
    try {
      var response = await _chatRepositoryImpl.createRequestSummaryText(
        content,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }
}

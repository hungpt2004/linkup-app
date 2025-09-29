abstract class ChatRepository {
  Future<Map<String, dynamic>> createChatBoxMessage(String content);
  Future<Map<String, dynamic>> findChatBoxHistory({
    int page = 1,
    int limit = 10,
  });
  Future<Map<String, dynamic>> createPromptGenImage();
  Future<Map<String, dynamic>> createRequestSummaryText(String content);
}

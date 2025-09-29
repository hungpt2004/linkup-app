import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/exception/exception_type.dart';
import 'package:vdiary_internship/core/network/dio_client.dart';
import 'package:vdiary_internship/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Map<String, dynamic>> createChatBoxMessage(String content) async {
    try {
      var response = await baseUrlHasToken.post(
        ApiEndPoint.sendMessageChat,
        data: {'message': content},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findChatBoxHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await baseUrlHasToken.get(
        ApiEndPoint.findHistoryChat,
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> createPromptGenImage() {
    // TODO: Create Prompt Generation Image
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createRequestSummaryText(String content) async {
    try {
      var response = await baseUrlHasToken.post(
        ApiEndPoint.requestSummaryText,
        data: {'message': content},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }
}

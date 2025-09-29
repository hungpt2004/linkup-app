import 'package:dio/dio.dart';
import '../../core/constants/api/end_point.dart';
import '../../core/exception/exception_base.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/exception/exception_type.dart';
import '../../core/network/dio_client.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Suggestions
  @override
  Future<Map<String, dynamic>> findAllUser() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findListUser}',
        queryParameters: {'type': TypeRequest.suggestions.name},
      );
      return response.data;
    } on DioException catch (error) {
      throw ExceptionHandler.handleDioException(error);
    } catch (error) {
      if (error is AppExceptionBase) rethrow;
      throw ServerException(
        errorMessage: 'Lỗi không xác định ${error.toString()}',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> findOneById(String userId) {
    // TODO: implement findOneById
    throw UnimplementedError();
  }
}

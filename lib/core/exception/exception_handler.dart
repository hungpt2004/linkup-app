import 'package:dio/dio.dart';
import 'exception_base.dart';
import 'exception_type.dart';

class ExceptionHandler {
  static AppExceptionBase handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          errorMessage: 'Kết nối timeout. Vui lòng thử lại.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return NoInternetException(
          errorMessage: 'Không có kết nối internet. Vui lòng kiểm tra lại.',
          code: 'NO_INTERNET',
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.cancel:
        return NetWorkException(
          errorMessage: 'Request was cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
        return NetWorkException(
          errorMessage: 'Lỗi không xác định. Vui lòng thử lại.',
          code: 'UNKNOWN_ERROR',
        );

      default:
        return NetWorkException(
          errorMessage: 'Something went wrong',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  static AppExceptionBase _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Trường hợp lấy message từ response có format khác
    String message = 'Unknown error';

    if (responseData is Map<String, dynamic>) {
      message =
          responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          'Unknown error';
    } else if (responseData is String) {
      message = responseData;
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(
          errorMessage: 'Yêu cầu không hợp lệ: $message',
          code: 'BAD_REQUEST',
        );
      case 401:
        return UnauthorizedException(
          errorMessage: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
          code: 'UNAUTHORIZED',
        );
      case 403:
        return AuthException(
          errorMessage: 'Không có quyền truy cập: $message',
          code: 'FORBIDDEN',
        );
      case 404:
        return ServerException(
          errorMessage: 'Không tìm thấy tài nguyên: $message',
          code: 'NOT_FOUND',
        );
      case 409:
        return ValidationException(
          errorMessage: 'Dữ liệu đã tồn tại: $message',
          code: 'CONFLICT',
        );
      case 422:
        return ValidationException(
          errorMessage: 'Dữ liệu không hợp lệ: $message',
          code: 'VALIDATION_ERROR',
        );
      case 429:
        return ServerException(
          errorMessage: 'Quá nhiều yêu cầu. Vui lòng thử lại sau.',
          code: 'TOO_MANY_REQUESTS',
        );
      case 500:
        return InternalServerException(
          errorMessage: 'Lỗi máy chủ nội bộ: $message',
          code: 'INTERNAL_SERVER_ERROR',
        );
      case 502:
        return ServerException(
          errorMessage: 'Máy chủ không khả dụng. Vui lòng thử lại sau.',
          code: 'BAD_GATEWAY',
        );
      case 503:
        return ServerException(
          errorMessage:
              'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.',
          code: 'SERVICE_UNAVAILABLE',
        );
      default:
        return ServerException(
          errorMessage: 'Lỗi máy chủ ($statusCode): $message',
          code: 'SERVER_ERROR_$statusCode',
        );
    }
  }

  static AppExceptionBase handleValidationErrors(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        // Convert validation errors to readable format
        final errorMessages = errors.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join(', ');

        return ValidationException(
          errorMessage: 'Lỗi validation: $errorMessages',
          code: 'VALIDATION_ERROR',
        );
      }
    }

    return ValidationException(
      errorMessage: 'Dữ liệu không hợp lệ',
      code: 'VALIDATION_ERROR',
    );
  }
}

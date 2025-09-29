import 'exception_base.dart';

// Lỗi mạng lỗi network
class NetWorkException extends AppExceptionBase {
  NetWorkException({required super.errorMessage, required super.code});
}

// Lỗi timeout
class TimeoutException extends AppExceptionBase {
  TimeoutException({
    super.errorMessage = 'Request timeout',
    super.code = 'TIMEOUT'
  });
}

class NoInternetException extends NetWorkException {
  NoInternetException({
    super.errorMessage = 'No internet connection',
    super.code = 'NO_INTERNET',
  });
}

/// Authentication related exceptions
class AuthException extends AppExceptionBase {
  AuthException({
    required super.errorMessage,
    required super.code,
  });
}

class UnauthorizedException extends AuthException {
  UnauthorizedException({
    super.errorMessage = 'Unauthorized access',
    super.code = 'UNAUTHORIZED',
  });
}

class TokenExpiredException extends AuthException {
  TokenExpiredException({
    super.errorMessage = 'Token has expired',
    super.code = 'TOKEN_EXPIRED',
  });
}

/// Server related exceptions
class ServerException extends AppExceptionBase {
  ServerException({
    required super.errorMessage,
    required super.code,
  });
}

class BadRequestException extends ServerException {
  BadRequestException({
    super.errorMessage = 'Bad request',
    super.code = 'BAD_REQUEST',
  });
}

class InternalServerException extends ServerException {
  InternalServerException({
    super.errorMessage = 'Internal server error',
    super.code = 'INTERNAL_SERVER_ERROR',
  });
}

/// Validation related exceptions
class ValidationException extends AppExceptionBase {
  ValidationException({
    required super.errorMessage,
    required super.code,
  });
}


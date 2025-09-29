abstract class AppExceptionBase implements Exception {
  final String errorMessage;
  final String code;

  AppExceptionBase({
    required this.errorMessage,
    required this.code
  });

  @override
  String toString() {
    return 'Có lỗi trả về $errorMessage với status-code là $code';
  }
}


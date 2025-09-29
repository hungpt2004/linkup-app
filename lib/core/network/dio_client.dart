import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// RELATIVE IMPORT
import '../constants/api/end_point.dart';
import 'interceptors/dio_interceptor_config.dart';

class DioClient {
  // Tạo dio client để tương tác mà không có header token
  static Dio createPublicDio() {
    debugPrint('BASE-URL: $baseUrl');
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }

  // Dio client có header token của user
  static Dio createPrivateDio() {
    debugPrint('BASE-URL:$baseUrl');
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    // 1) chèn token trước
    dio.interceptors.add(DioInterceptorConfig());

    // 2) sau cùng mới log
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}

final baseUrlNoToken = DioClient.createPublicDio();
final baseUrlHasToken = DioClient.createPrivateDio();

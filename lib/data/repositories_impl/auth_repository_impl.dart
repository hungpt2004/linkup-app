import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api/end_point.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/exception/exception_type.dart';
import '../../core/network/dio_client.dart';
import '../models/user/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final baseUrlHeader = DioClient.createPublicDio();

  @override
  Future<List<UserModel>> findAll() async {
    try {
      var response = await baseUrlHeader.get(ApiEndPoint.findAllUser);
      return response.data;
    } on DioException catch (error) {
      debugPrint(error.toString());
      throw ExceptionHandler.handleDioException(error);
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }

  @override
  Future<Map<String, dynamic>> profileUser() async {
    try {
      var response = await baseUrlHasToken.get('${ApiEndPoint.findUserId}');
      return response.data;
    } on DioException catch (error) {
      debugPrint(error.toString());
      throw ExceptionHandler.handleDioException(error);
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    debugPrint(email);
    debugPrint(password);
    try {
      // Api trả về id, name, email
      var response = await baseUrlHeader.post(
        ApiEndPoint.signIn,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      var response = await baseUrlHeader.post(
        ApiEndPoint.signUp,
        data: {'name': name, 'email': email, 'password': password},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }

  @override
  Future<Map<String, dynamic>> updateAvatar(String imagePath) async {
    try {
      final file = File(imagePath);

      if (!file.existsSync()) {
        debugPrint('File ảnh không tồn tại');
        return {};
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
          filename: file.uri.pathSegments.last,
        ),
        'type': TypeUpload.avatar.name,
      });

      var response = await baseUrlHasToken.patch(
        ApiEndPoint.uploadAvatar,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }

  @override
  Future<Map<String, dynamic>> updateBackground(String imagePath) async {
    try {
      final file = File(imagePath);

      if (!file.existsSync()) {
        debugPrint('File ảnh không tồn tại');
        return {};
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
          filename: file.uri.pathSegments.last,
        ),
        'type': TypeUpload.background.name,
      });

      var response = await baseUrlHasToken.patch(
        ApiEndPoint.background,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: '500');
    }
  }
}

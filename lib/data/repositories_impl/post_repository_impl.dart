import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api/end_point.dart';
import '../../core/exception/exception_type.dart';
import '../../core/network/dio_client.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Map<String, dynamic>> createNewPost({
    required String caption,
    List<String>? imagePaths,
    List<String>? videoPaths,
    List<Map<String, dynamic>>? links,
    List<String>? hashtags,
    List<String>? mentions,
    String privacy = 'public',
  }) async {
    try {
      final formData = FormData();

      // Add basic data - LUÔN gửi tất cả fields để tránh undefined
      formData.fields.addAll([
        MapEntry('caption', caption.toString()),
        MapEntry('privacy', privacy.toString()),
      ]);

      if (hashtags != null && hashtags.isNotEmpty) {
        formData.fields.add(MapEntry('hashtags', jsonEncode(hashtags)));
        debugPrint('Request hashtags: ${jsonEncode(hashtags)}');
      } else {
        formData.fields.add(MapEntry('hashtags', '[]'));
      }

      // Gửi mentions như JSON array string
      if (mentions != null && mentions.isNotEmpty) {
        formData.fields.add(MapEntry('mentions', jsonEncode(mentions)));
        debugPrint('Request mentions: ${jsonEncode(mentions)}');
      } else {
        formData.fields.add(MapEntry('mentions', '[]'));
      }

      // Chỉ gửi links khi có data - không gửi empty array vì backend default: null
      if (links != null && links.isNotEmpty) {
        formData.fields.add(MapEntry('links', jsonEncode(links)));
        debugPrint('Request links: ${jsonEncode(links)}');
      }

      // Add image files
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (int i = 0; i < imagePaths.length; i++) {
          final imagePath = imagePaths[i];
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                imagePath,
                filename: imagePath.split('/').last,
              ),
            ),
          );
        }
      }

      // Add video files
      if (videoPaths != null && videoPaths.isNotEmpty) {
        for (int i = 0; i < videoPaths.length; i++) {
          final videoPath = videoPaths[i];
          formData.files.add(
            MapEntry(
              'videos',
              await MultipartFile.fromFile(
                videoPath,
                filename: videoPath.split('/').last,
              ),
            ),
          );
        }
      }

      var response = await baseUrlHasToken.post(
        ApiEndPoint.createNewPost,
        data: formData,
      );

      return response.data;
    } catch (err) {
      throw ServerException(errorMessage: err.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findAllNewFeeds({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await baseUrlHasToken.get(
        ApiEndPoint.findNewfeedPost,
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findNewFeedId(String id) async {
    debugPrint('PostRepositoryImpl: Finding new feed by ID: $id');
    debugPrint(
      'PostRepositoryImpl: API endpoint: ${ApiEndPoint.findNewfeedPostDetail}/$id',
    );
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findNewfeedPostDetail}/$id',
      );
      debugPrint('PostRepositoryImpl: API response: ${response.data}');
      return response.data;
    } catch (error) {
      debugPrint(
        'PostRepositoryImpl: Error finding new feed by ID: ${error.toString()}',
      );
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> dislikePost(String postId) async {
    try {
      var response = await baseUrlHasToken.delete(
        '${ApiEndPoint.findNewfeedPost}/$postId/${TypePostAction.dislike.name}',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> likePost(String postId, String typeReact) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.findNewfeedPost}/$postId/${TypePostAction.like.name}',
        data: {'typeReact': typeReact},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findOwnPost() async {
    try {
      var response = await baseUrlHasToken.get(ApiEndPoint.findOwnPost);
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findPostByUserId(String userId) async {
    try {
      var response = await baseUrlNoToken.get(
        '${ApiEndPoint.findPostByUserId}/$userId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findUserPosts({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findPostByUserId}/$userId',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> updatePost(
    String postId,
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await baseUrlHasToken.put(
        '${ApiEndPoint.updatePost}$postId',
        data: postData,
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> deletePost(String postId) async {
    try {
      var response = await baseUrlHasToken.delete(
        '${ApiEndPoint.deletePost}$postId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> createNewComment(
    String postId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  ) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.createNewComment}/$postId',
        data: {'text': text, 'mentions': mentions ?? [], 'likes': likes ?? []},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      var response = await baseUrlHasToken.delete(
        '${ApiEndPoint.deleteComment}/$commentId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findCommentByPostId(String postId) async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findCommentByPost}/$postId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> updateComment(String commentId) {
    // TODO: implement updateComment
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createChildComment(
    String postId,
    String parentId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  ) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.createChildComment}/$postId/$parentId',
        data: {'text': text, 'mentions': mentions ?? [], 'likes': likes ?? []},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findChildCommentByCommentId(
    String commentId,
  ) async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findChildComment}/$commentId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> countNumberComment(String postId) async {
    try {
      var response = await baseUrlNoToken.get(
        '${ApiEndPoint.countCommentNumber}/$postId',
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findReactionByType(
    String postId,
    String type,
  ) async {
    try {
      var response = await baseUrlNoToken.get(
        '${ApiEndPoint.findReactionByType}/$postId',
        data: {'typeReact': type},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }
}

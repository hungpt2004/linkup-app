import 'package:flutter/rendering.dart';
import 'package:vdiary_internship/data/repositories_impl/post_repository_impl.dart';

class PostService {
  final PostRepositoryImpl _postRepositoryImpl = PostRepositoryImpl();

  // FIND NEW FEED
  Future<Map<String, dynamic>> findAllNewFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await _postRepositoryImpl.findAllNewFeeds(
        page: page,
        limit: limit,
      );
      debugPrint('Dữ liệu new feed: $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // DISLIKE POST
  Future<Map<String, dynamic>> likePost(String postId, String typeReact) async {
    try {
      var response = await _postRepositoryImpl.likePost(postId, typeReact);
      return response; // response message, result
    } catch (error) {
      rethrow;
    }
  }

  // LIKE POST
  Future<Map<String, dynamic>> dislikePost(String postId) async {
    try {
      var response = await _postRepositoryImpl.dislikePost(postId);
      return response; // response message, result
    } catch (error) {
      rethrow;
    }
  }

  // FIND OWN POSTS
  Future<Map<String, dynamic>> findOwnPost() async {
    try {
      var response = await _postRepositoryImpl.findOwnPost();
      debugPrint('Dữ liệu own posts: $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // FIND USER POSTS BY USER ID
  Future<Map<String, dynamic>> findUserPosts({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var response = await _postRepositoryImpl.findUserPosts(
        userId: userId,
        page: page,
        limit: limit,
      );
      debugPrint('Dữ liệu user posts: $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // FIND REACTION BY REACTION TYPE
  Future<Map<String, dynamic>> findReactionByType(
    String postId,
    String typeReact,
  ) async {
    try {
      var response = await _postRepositoryImpl.findReactionByType(
        postId,
        typeReact,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // LOAD POST DETAIL
  Future<Map<String, dynamic>> loadPostDetail(String id) async {
    debugPrint('PostService: Loading post detail for ID: $id');
    try {
      var response = await _postRepositoryImpl.findNewFeedId(id);
      debugPrint('PostService: Repository response: $response');
      return response;
    } catch (error) {
      debugPrint('PostService: Error loading post detail: ${error.toString()}');
      rethrow;
    }
  }

  // UPDATE POST
  Future<Map<String, dynamic>> updatePost(
    String postId,
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await _postRepositoryImpl.updatePost(postId, postData);
      debugPrint('Update post response: $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // DELETE POST
  Future<Map<String, dynamic>> deletePost(String postId) async {
    try {
      var response = await _postRepositoryImpl.deletePost(postId);
      debugPrint('Delete post response: $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // COMMENT POST
  Future<Map<String, dynamic>> createComment(
    String postId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  ) async {
    try {
      var response = await _postRepositoryImpl.createNewComment(
        postId,
        text,
        mentions,
        likes,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // CREATE CHILD COMMENT
  Future<Map<String, dynamic>> createChildComment(
    String postId,
    String parentId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  ) async {
    try {
      var response = await _postRepositoryImpl.createChildComment(
        postId,
        parentId,
        text,
        mentions,
        likes,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // GET COMMENT POST
  Future<Map<String, dynamic>> loadPostComment(String postId) async {
    try {
      var reponse = await _postRepositoryImpl.findCommentByPostId(postId);
      return reponse;
    } catch (error) {
      rethrow;
    }
  }

  // GET CHILD COMMENT POST
  Future<Map<String, dynamic>> loadChildComment(String commentId) async {
    try {
      var response = await _postRepositoryImpl.findChildCommentByCommentId(
        commentId,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // UPDATE COMMENT POST
  Future<Map<String, dynamic>> updatePostComment(String commentId) async {
    return {};
  }

  // GET NUMBER COMMENT OF POST
  Future<Map<String, dynamic>> getCountCommentOfPost(String postId) async {
    try {
      var response = await _postRepositoryImpl.countNumberComment(postId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // DELETE COMMENT POST
  Future<Map<String, dynamic>> deletePostComment(String commentId) async {
    try {
      var response = await _postRepositoryImpl.deleteComment(commentId);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}

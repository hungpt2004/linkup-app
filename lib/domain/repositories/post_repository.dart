abstract class PostRepository {
  // ## POST
  Future<Map<String, dynamic>> findAllNewFeeds({int page = 1, int limit = 10});
  Future<Map<String, dynamic>> createNewPost({
    required String caption,
    List<String>? imagePaths,
    List<String>? videoPaths,
    List<Map<String, dynamic>>? links,
    List<String>? hashtags,
    List<String>? mentions,
    String privacy = 'public',
  });
  Future<Map<String, dynamic>> findNewFeedId(String id);
  Future<Map<String, dynamic>> likePost(String postId, String typeReact);
  Future<Map<String, dynamic>> dislikePost(String postId);
  Future<Map<String, dynamic>> findOwnPost();
  Future<Map<String, dynamic>> findPostByUserId(String userId);
  Future<Map<String, dynamic>> findReactionByType(String post, String type);
  Future<Map<String, dynamic>> findUserPosts({
    required String userId,
    int page = 1,
    int limit = 10,
  });
  Future<Map<String, dynamic>> updatePost(
    String postId,
    Map<String, dynamic> postData,
  );
  Future<Map<String, dynamic>> deletePost(String postId);

  // ##COMMENT
  Future<Map<String, dynamic>> findCommentByPostId(String postId);
  Future<Map<String, dynamic>> findChildCommentByCommentId(String commentId);
  Future<Map<String, dynamic>> createNewComment(
    String postId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  );
  Future<Map<String, dynamic>> createChildComment(
    String postId,
    String parentId,
    String text,
    List<String>? mentions,
    List<String>? likes,
  );
  Future<Map<String, dynamic>> updateComment(String commentId);
  Future<Map<String, dynamic>> deleteComment(String commentId);
  Future<Map<String, dynamic>> countNumberComment(String postId);
}

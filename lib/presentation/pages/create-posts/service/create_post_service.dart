import 'package:vdiary_internship/data/repositories_impl/post_repository_impl.dart';

class CreatePostService {
  final PostRepositoryImpl _postRepository = PostRepositoryImpl();

  // Create new post
  Future<Map<String, dynamic>> createPost({
    required String caption,
    List<String>? imagePaths,
    List<String>? videoPaths,
    List<Map<String, dynamic>>? links,
    List<String>? hashtags,
    List<String>? mentions,
    String privacy = 'public',
  }) async {
    try {
      var response = await _postRepository.createNewPost(
        caption: caption,
        imagePaths: imagePaths,
        videoPaths: videoPaths,
        links: links,
        hashtags: hashtags,
        mentions: mentions,
        privacy: privacy,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }
}

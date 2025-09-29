import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/core/constants/routes/hive_path.dart';
import 'package:vdiary_internship/data/models/post/comment_model.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import 'package:vdiary_internship/presentation/shared/extensions/hive_convert_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/model_convert_extension.dart';
import 'package:vdiary_internship/data/models/post/hive/post_model_hive.dart';
import 'package:vdiary_internship/presentation/shared/utils/hive_utils.dart';
import 'package:vdiary_internship/presentation/shared/store/store_factory.dart';

// relative service
import '../services/post_service.dart';

// generate json
part 'post_store.g.dart';

// ignore: library_private_types_in_public_api
class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  final PostService _postService = PostService();

  // Observable states
  @observable
  bool isLoading = false;

  @observable
  bool isInitializing = false;

  @observable
  String? errorMessage;

  @observable
  String commentInput = '';

  @observable
  String replyToUser = '';

  @observable
  String parentCommentId = '';

  @observable
  ObservableList<PostModel> posts = ObservableList<PostModel>();

  @observable
  ObservableList<PostModel> cachedPosts = ObservableList<PostModel>();

  @observable
  ObservableList<Map<String, dynamic>> stories =
      ObservableList<Map<String, dynamic>>();

  @observable
  bool isRefreshing = false;

  @observable
  bool isLoadMore = false;

  @observable
  bool hasMorePosts = true;

  @observable
  bool isPreviewLink = false;

  @observable
  int currentPage = 1;

  @observable
  bool friendsOnly = false;

  @observable
  bool isLoadedFromCache = false;

  @observable
  ObservableList<UserEntity> shareUserLists = ObservableList<UserEntity>();

  @observable
  ObservableMap<String, bool> selectedUsersMap = ObservableMap<String, bool>();

  @observable
  String shareSearchQuery = '';

  @observable
  ObservableMap<String, List<LikeModel>> listLikeUsers =
      ObservableMap<String, List<LikeModel>>();

  @observable
  ObservableMap<String, int> likeCount = ObservableMap<String, int>();

  @observable
  ObservableMap<String, List<LikeModel>> mapReactionByType =
      ObservableMap<String, List<LikeModel>>();

  @observable
  PostModel? postDetail;

  @observable
  ObservableList<CommentModel> listComments = ObservableList<CommentModel>();

  @observable
  ObservableMap<String, List<CommentModel>> mapPostComments =
      ObservableMap<String, List<CommentModel>>();

  // Lưu list child comment theo parent comment id
  @observable
  ObservableMap<String, List<CommentModel>> mapCommentWithChildComments =
      ObservableMap<String, List<CommentModel>>();

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setInitializing(bool value) => isInitializing = value;

  @action
  void setParentCommentId(String commentId) => parentCommentId = commentId;

  @action
  void setFriendsOnly(bool value) => friendsOnly = value;

  @action
  void setLoadedFromCache(bool value) => isLoadedFromCache = value;

  @action
  void setRefreshing(bool value) => isRefreshing = value;

  @action
  void setIsPreviewLink(bool value) => isPreviewLink = value;

  @action
  void setLoadMore(bool value) => isLoadMore = value;

  @action
  void setError(String? error) => errorMessage = error;

  @action
  void setCommentInputValue(String value) => commentInput = value;

  @action
  void setReplyInputValue(String value) => replyToUser = value;

  @action
  void setCommentHaveReplyValue() {
    if (replyToUser.isNotEmpty) {
      setCommentInputValue(replyToUser);
    } else {
      setCommentInputValue('');
    }
  }

  @action
  void clearCommentInput() => setCommentInputValue('');

  @action
  void resetCommentForm() {
    debugPrint('TRONG STORE: $parentCommentId');
    setCommentInputValue('');
    setReplyInputValue('');
    setParentCommentId('');
    clearCommentInput();
  }

  @action
  void clearError() => errorMessage = null;

  @action
  void clear() {
    posts.clear();
    stories.clear();
    listLikeUsers.clear();
    likeCount.clear();
    listComments.clear();
    postDetail = null;
  }

  // Toggle friends filter
  @action
  Future<void> toggleFriendsFilter() async {
    friendsOnly = !friendsOnly;
    await loadPosts(refresh: true);
  }

  @action
  void clearShareUserLists() {
    shareUserLists.clear();
    selectedUsersMap.clear();
  }

  @action
  bool checkUserExist(String userId) {
    return selectedUsersMap.containsKey(userId) &&
        selectedUsersMap[userId] == true;
  }

  @action
  void addOrRemoveShareUserList(UserEntity newUser) {
    final isSelected = checkUserExist(newUser.id);
    if (isSelected) {
      shareUserLists.removeWhere((user) => user.id == newUser.id);
      selectedUsersMap[newUser.id] = false;
    } else {
      if (!shareUserLists.any((user) => user.id == newUser.id)) {
        shareUserLists.add(newUser);
      }
      selectedUsersMap[newUser.id] = true;
    }
  }

  @action
  void setShareSearchQuery(String query) => shareSearchQuery = query;

  @action
  void toggleUserSelection(UserEntity user) {
    final isCurrentlySelected = checkUserExist(user.id);
    if (isCurrentlySelected) {
      selectedUsersMap[user.id] = false;
      shareUserLists.removeWhere((u) => u.id == user.id);
    } else {
      selectedUsersMap[user.id] = true;
      if (!shareUserLists.any((u) => u.id == user.id)) {
        shareUserLists.add(user);
      }
    }
  }

  @action
  void selectAllUsers(List<UserEntity> users) {
    for (final user in users) {
      selectedUsersMap[user.id] = true;
      if (!shareUserLists.any((u) => u.id == user.id)) {
        shareUserLists.add(user);
      }
    }
  }

  @action
  void unselectAllUsers() {
    selectedUsersMap.clear();
    shareUserLists.clear();
  }

  // Load posts with pagination
  @action
  Future<void> loadPosts({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage = 1;
        posts.clear();
        hasMorePosts = true;
        setLoadedFromCache(false);
      } else {
        setLoading(true);
      }

      clearError();

      final response = await _postService.findAllNewFeed(
        page: currentPage,
        limit: 10,
      );

      // response is non-nullable Map from service; check for 'posts' key
      if (response['posts'] != null) {
        final List<dynamic> postsData = response['posts'] as List<dynamic>;
        final List<PostModel> newPosts =
            postsData.map((postJson) => PostModel.fromJson(postJson)).toList();
        posts.addAll(newPosts);

        for (final post in newPosts) {
          likeCount[post.id] = post.likeCount;
          listLikeUsers[post.id] = post.listUsers;

          // Khởi tạo mapPostComments với list rỗng nếu chưa có
          if (mapPostComments[post.id] == null) {
            mapPostComments[post.id] = [];
          }
        }

        final int total = response['total'] ?? 0;
        final int limit = response['limit'] ?? 10;
        final int currentPageFromResponse = response['page'] ?? currentPage;

        currentPage = currentPageFromResponse + 1;

        if (posts.length >= total || newPosts.length < limit) {
          hasMorePosts = false;
        }
      } else {
        setError('Không có dữ liệu bài viết');
      }
    } catch (e) {
      setError('Lỗi khi tải bài viết: ${e.toString()}');
    } finally {
      if (refresh) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      setLoading(false);
      setRefreshing(false);
    }
  }

  // Save post cache hive
  @action
  Future<void> cacheTopPostsToHive() async {
    try {
      final box = await HiveUtils.openBoxSafely<PostModelHive>(
        HiveBoxName.cachedPost,
      );
      await box.clear();

      final topPosts =
          posts.take(10).map((post) => post.toPostModelHive()).toList();

      await box.addAll(topPosts);
      await box.close(); // Close the box after use
    } catch (e) {
      debugPrint('Lỗi cacheTopPostsToHive: $e');
    }
  }

  // Get post cache hive
  @action
  Future<void> loadPostsFromHive() async {
    try {
      final box = await HiveUtils.openBoxSafely<PostModelHive>(
        HiveBoxName.cachedPost,
      );

      // Lấy giá trị list post lưu trong HIVE
      final cachedPosts = box.values.toList();

      // Đưa value post trong Hive thành PostModel
      if (cachedPosts.isNotEmpty) {
        final postLists =
            cachedPosts.map((post) => post.toPostModel()).toList();

        // Lưu vào list posts để hiển thị trên UI
        posts
          ..clear()
          ..addAll(postLists);

        for (final post in postLists) {
          listLikeUsers[post.id] = post.listUsers;
          likeCount[post.id] = post.likeCount;
        }

        // Loading
        setLoadedFromCache(true);
      } else {
        setLoadedFromCache(false);
      }

      await box.close();

      // Also load offline posts and add them to the main posts list
      await _loadOfflinePostsIntoFeed();
    } catch (e) {
      setLoadedFromCache(false);
      debugPrint('Lỗi loadPostsFromHive: $e');
    }
  }

  // Lấy post từ cached thêm vào post hiển thị trên UI
  @action
  Future<void> _loadOfflinePostsIntoFeed() async {
    try {
      final createPostStore = StoreFactory.createPostStore;

      // Make sure the createPostStore is initialized and has loaded its offline posts
      if (createPostStore.postNeedWifi.isNotEmpty) {
        for (int i = createPostStore.postNeedWifi.length - 1; i >= 0; i--) {
          final offlinePost = createPostStore.postNeedWifi[i];
          // Add những post nào chưa có trong list
          if (!posts.any((post) => post.id == offlinePost.id)) {
            posts.insert(0, offlinePost);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading offline posts into feed: $e');
    }
  }

  // Post like
  @action
  Future<bool> toggleLike(String postId, String typeReact) async {
    try {
      final response = await _postService.likePost(postId, typeReact);
      if (response['post'] != null) {
        final postData = response['post'];
        final int updatedLikeCount = postData['likeCount'] ?? 0;
        final List<dynamic> rawLikes = postData['likes'] ?? [];
        final List<LikeModel> listLikes =
            rawLikes.map((e) => LikeModel.fromJson(e)).toList();
        likeCount[postId] = updatedLikeCount;
        listLikeUsers[postId] = listLikes;
        return true;
      }
      return false;
    } catch (e) {
      setError('Không thể thích bài viết: ${e.toString()}');
      return false;
    }
  }

  // Post dislike
  @action
  Future<bool> toggleDislike(String postId) async {
    try {
      final response = await _postService.dislikePost(postId);
      if (response['post'] != null) {
        // Xóa user khỏi danh sách like của post
        final List<dynamic> rawLikes = response['post']['likes'] ?? [];
        final List<LikeModel> listLikes =
            rawLikes.map((e) => LikeModel.fromJson(e)).toList();
        listLikeUsers[postId] = listLikes;
        likeCount[postId] =
            response['post']['likeCount'] ?? ((likeCount[postId] ?? 1) - 1);
        return true;
      }
      return false;
    } catch (e) {
      setError('Không thể bỏ thích bài viết: ${e.toString()}');
      return false;
    }
  }

  // Load post detail
  @action
  Future<bool> loadPostDetail(String id) async {
    setLoading(true);
    try {
      final response = await _postService.loadPostDetail(id);
      if (response['result'] != null) {
        postDetail = PostModel.fromJson(response['result']);
        return true;
      }
      postDetail = null;
      return false;
    } catch (error) {
      setError(error.toString());
      postDetail = null;
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Load post detail silently (không hiển thị loading)
  @action
  Future<bool> loadPostDetailSilently(String id) async {
    debugPrint('PostStore: Loading post detail silently for ID: $id');
    try {
      final response = await _postService.loadPostDetail(id);
      debugPrint('PostStore: Post service response: $response');
      if (response['result'] != null) {
        postDetail = PostModel.fromJson(response['result']);
        debugPrint('PostStore: Post detail loaded successfully');
        return true;
      } else {
        debugPrint('PostStore: No result in response');
        return false;
      }
    } catch (error) {
      debugPrint(
        'PostStore: Error loading post detail silently: ${error.toString()}',
      );
      return false;
    }
  }

  @action
  Future<bool> sharePost(String postId) async {
    try {
      // Placeholder: implement service call if available
      return true;
    } catch (e) {
      setError('Không thể chia sẻ bài viết: ${e.toString()}');
      return false;
    }
  }

  // Load stories (mock)
  @action
  Future<void> loadStories() async {
    try {
      setLoading(true);
      clearError();
      await Future.delayed(const Duration(milliseconds: 300));
      stories.clear();
      stories.addAll([
        {
          'id': 1,
          'userId': 1,
          'userName': 'Bạn',
          'userAvatar':
              'https://i.pinimg.com/736x/3f/18/28/3f1828dd47ac78756c5957fcb57c3849.jpg',
          'storyImage': null,
          'isAddStory': true,
        },
      ]);
    } catch (e) {
      setError('Không thể tải stories: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  @action
  void clearListComments() {
    listComments.clear();
    debugPrint('Cleared comments list');
  }

  // Get danh sách comment theo post id
  @action
  Future<void> loadListCommentByPost(String postId) async {
    try {
      final response = await _postService.loadPostComment(postId);
      // ignore: unnecessary_type_check
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List<dynamic> raw = response['data'] as List<dynamic>;
        final List<CommentModel> parsed =
            raw
                .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
                .toList();

        listComments
          ..clear()
          ..addAll(parsed);

        mapPostComments[postId] = List<CommentModel>.from(parsed);

        // Lấy child comment cho từng comment cha
        for (final comment in parsed) {
          if (comment.id != null) {
            await loadAndSaveChildComments(comment.id!);
          }
        }
      } else {
        listComments.clear();
      }
    } catch (error, st) {
      debugPrint('Error when load list comment: ${error.toString()}');
      debugPrint(st.toString());
    }
  }

  // Lấy và lưu child comment cho từng comment cha
  @action
  Future<void> loadAndSaveChildComments(String parentCommentId) async {
    try {
      final response = await _postService.loadChildComment(parentCommentId);
      // ignore: unnecessary_type_check
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List<dynamic> raw = response['data'] as List<dynamic>;
        debugPrint('SỐ LƯỢNG CHILD COMMENT ------ ${raw.length}');
        final List<CommentModel> parsed =
            raw
                .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
                .toList();

        // Lấy danh sách id hiện tại
        final existing = mapCommentWithChildComments[parentCommentId] ?? [];
        final existingIds = existing.map((c) => c.id).toSet();

        // Chỉ thêm những comment chưa có id trong danh sách
        final List<CommentModel> merged = List<CommentModel>.from(existing);
        for (final child in parsed) {
          if (child.id != null && !existingIds.contains(child.id)) {
            merged.add(child);
          }
        }
        mapCommentWithChildComments[parentCommentId] = merged;
      } else {
        mapCommentWithChildComments[parentCommentId] = [];
      }
    } catch (error) {
      debugPrint('Error load child comments: ${error.toString()}');
      mapCommentWithChildComments[parentCommentId] = [];
    }
  }

  // Tạo comment cha
  @action
  Future<bool> createNewComment(String postId, String text) async {
    try {
      // Tìm các mentions dạng @username trong text
      final mentionRegex = RegExp(r'@([\w\d_]+)');
      final matches = mentionRegex.allMatches(text);
      final mentions =
          matches
              .map((m) => m.group(1) ?? '')
              .where((s) => s.isNotEmpty)
              .toList();

      final response = await _postService.createComment(
        postId,
        text,
        mentions,
        [], // likes mặc định rỗng
      );

      // Nếu tạo comment thành công, thêm vào cả listComments và mapPostComments
      if (response['result'] != null) {
        final newComment = CommentModel.fromJson(response['result']);

        // Thêm vào listComments (cho UI hiện tại)
        listComments.add(newComment);

        // Thêm vào mapPostComments (tạo copy mới nếu chưa có)
        if (mapPostComments[postId] != null) {
          mapPostComments[postId] = List<CommentModel>.from(
            mapPostComments[postId]!,
          )..add(newComment);
        } else {
          mapPostComments[postId] = [newComment];
        } // Cập nhật comments count trong post gốc nếu có

        debugPrint('Added new comment to list: ${newComment.text}');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  // Tạo comment con
  @action
  Future<bool> createChildComment(
    String postId,
    String parentId,
    String text,
  ) async {
    try {
      // Tìm các mentions dạng @username trong text
      final mentionRegex = RegExp(r'@([\w\d_]+)');
      final matches = mentionRegex.allMatches(text);
      final mentions =
          matches
              .map((m) => m.group(1) ?? '')
              .where((s) => s.isNotEmpty)
              .toList();

      final response = await _postService.createChildComment(
        postId,
        parentId,
        text,
        mentions,
        [], // likes mặc định rỗng
      );

      if (response['result'] != null) {
        final newComment = CommentModel.fromJson(response['result']);

        // Thêm vào listComments nếu chưa có (để build cây và render ngay)
        if (newComment.id != null &&
            !listComments.any((c) => c.id == newComment.id)) {
          listComments.add(newComment);
        }

        // Thêm vào danh sách child comment của parentId nếu chưa có
        final currentList = mapCommentWithChildComments[parentId] ?? [];
        if (newComment.id != null &&
            !currentList.any((c) => c.id == newComment.id)) {
          mapCommentWithChildComments[parentId] = List<CommentModel>.from(
            currentList,
          )..add(newComment);
        }

        // Đồng bộ lại với backend (nếu backend có logic khác)
        await loadAndSaveChildComments(parentId);

        debugPrint(
          'Added new child comment to parent $parentId: ${newComment.text}',
        );
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  // Update comment
  @action
  Future<bool> updateComment(String text) async {
    return false;
  }

  // Xóa comment
  @action
  Future<void> deleteComment(String commentId) async {
    try {
      // Tìm comment và postId trước khi xóa
      // ignore: unused_local_variable
      String? deletedPostId;
      for (String postId in mapPostComments.keys) {
        if (mapPostComments[postId]!.any(
          (comment) => comment.id == commentId,
        )) {
          deletedPostId = postId;
          break;
        }
      }

      var response = await _postService.deletePostComment(commentId);
      if (response['result']['success'] == true) {
        listComments.removeWhere((item) => item.id == commentId);

        // Xóa khỏi mapPostComments và giảm comments count
        mapPostComments.forEach((postId, comments) {
          comments.removeWhere((item) => item.id == commentId);
        });

        // Xóa khỏi tất cả danh sách child comment
        removeCommentFromChildMaps(commentId);
      }
    } catch (error) {
      debugPrint('Error delete comment: ${error.toString()}');
    }
  }

  // Xóa comment khỏi tất cả danh sách child comment
  void removeCommentFromChildMaps(String commentId) {
    for (final parentId in mapCommentWithChildComments.keys) {
      final childComments = mapCommentWithChildComments[parentId];
      if (childComments != null) {
        List<CommentModel> filtered = [];
        for (final item in childComments) {
          if (item.id != commentId) filtered.add(item);
        }
        mapCommentWithChildComments[parentId] = filtered;
      }
    }
  }

  /// Cập nhật post
  @action
  Future<bool> updatePost(String postId, Map<String, dynamic> postData) async {
    try {
      final response = await _postService.updatePost(postId, postData);

      if (response['result'] != null) {
        final updatedPost = PostModel.fromJson(response['result']);

        // Cập nhật trong danh sách posts
        final index = posts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          posts[index] = updatedPost;
        }

        // Cập nhật postDetail nếu đang xem chi tiết
        if (postDetail?.id == postId) {
          postDetail = updatedPost;
        }

        debugPrint('Updated post: ${updatedPost.caption}');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('Error updating post: ${error.toString()}');
      setError('Không thể cập nhật bài viết: ${error.toString()}');
      return false;
    }
  }

  /// Xóa post
  @action
  Future<bool> deletePost(String postId) async {
    try {
      final response = await _postService.deletePost(postId);

      if (response['message'] != null &&
          response['message'] == 'Delete post success') {
        // Xóa post khỏi danh sách
        posts.removeWhere((post) => post.id == postId);

        // Clear postDetail nếu đang xem chi tiết post bị xóa
        if (postDetail?.id == postId) {
          postDetail = null;
        }

        debugPrint('Deleted post: $postId');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('Error deleting post: ${error.toString()}');
      setError('Không thể xóa bài viết: ${error.toString()}');
      return false;
    }
  }

  @action
  Future<void> getReactionByTypeReact(String postId, String typeReact) async {
    try {
      var response = await _postService.findReactionByType(postId, typeReact);
      // ignore: unnecessary_null_comparison
      if (response != null && response['users'] is List) {
        final List<dynamic> usersData = response['users'];
        final List<LikeModel> likeModels =
            usersData.map((item) => LikeModel.fromJson(item)).toList();
        // Lưu vào map với key là '$postId-$typeReact'
        mapReactionByType['$postId-$typeReact'] = likeModels;
      }
    } catch (error) {
      debugPrint('Error getReactionByTypeReact: $error');
    }
  }

  // Kiểm tra user đã react chưa
  bool hasUserReacted(String postId, String userId) {
    try {
      final post = posts.firstWhere((p) => p.id == postId);
      return post.listUsers.any((like) => like.user.id == userId);
    } catch (e) {
      return false;
    }
  }

  // Lấy loại reaction của user với post
  String? getUserReactionType(String postId, String userId) {
    try {
      final post = posts.firstWhere((p) => p.id == postId);
      final like = post.listUsers.firstWhere(
        (like) => like.user.id == userId,
        orElse: () => throw StateError('Not found'),
      );
      return like.typeReact;
    } catch (e) {
      return null;
    }
  }

  // Computed values
  @computed
  int get postsCount => posts.length;

  @computed
  int get storiesCount => stories.length;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  int get selectedUsersCount => shareUserLists.length;

  @computed
  bool get hasSelectedUsers => shareUserLists.isNotEmpty;

  @computed
  List<UserEntity> get filteredShareUsers {
    if (shareSearchQuery.isEmpty) return shareUserLists;
    return shareUserLists.where((user) {
      final fullname = user.fullname.toLowerCase();
      final username = user.username.toLowerCase();
      final query = shareSearchQuery.toLowerCase();
      return fullname.contains(query) || username.contains(query);
    }).toList();
  }

  @action
  Future<void> initialize() async {
    setInitializing(true);

    // First try to load from cache to show something immediately
    await loadPostsFromHive();

    // Then load from API to get fresh data
    await loadPosts(refresh: true);

    // Cache the fresh data
    await cacheTopPostsToHive();

    // Load stories
    await loadStories();

    setInitializing(false);
  }

  @action
  Future<void> refreshPostDetailAndComments(String postId) async {
    await Future.wait([loadPostDetail(postId), loadListCommentByPost(postId)]);
  }

  @action
  Future<void> loadMorePosts() async {
    if (!hasMorePosts || isLoading) return;
    await loadPosts();
  }

  @action
  Future<void> refresh() async {
    await initialize();
  }
}

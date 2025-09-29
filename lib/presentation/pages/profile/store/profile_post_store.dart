import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/services/post_service.dart';

part 'profile_post_store.g.dart';

// ignore: library_private_types_in_public_api
class ProfilePostStore = _ProfilePostStore with _$ProfilePostStore;

abstract class _ProfilePostStore with Store {
  final PostService _postService = PostService();

  // Observable states
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<PostModel> ownPosts = ObservableList<PostModel>();

  @observable
  ObservableList<PostModel> userPosts = ObservableList<PostModel>();

  @observable
  bool isRefreshing = false;

  @observable
  int currentPage = 1;

  @observable
  bool hasMoreData = true;

  @observable
  String? currentUserId;

  // Actions
  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setRefreshing(bool value) {
    isRefreshing = value;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void clearAllPosts() {
    debugPrint('🧹 ProfilePostStore: Clearing all posts');
    ownPosts.clear();
    userPosts.clear();
    currentUserId = null;
    currentPage = 1;
    hasMoreData = true;
    clearError();
  }

  // Load own posts
  @action
  Future<void> loadOwnPosts({bool refresh = false}) async {
    try {
      debugPrint('🔄 ProfilePostStore: Loading OWN posts');

      if (refresh) {
        setRefreshing(true);
        ownPosts.clear();
      } else {
        setLoading(true);
      }

      // Clear user posts khi load own posts để tránh confusion
      userPosts.clear();
      currentUserId = null;

      clearError();

      // Call API through service
      final response = await _postService.findOwnPost();

      // Check if response has result data
      if (response['posts'] != null) {
        final List<dynamic> postsData = response['posts'];

        debugPrint('📊 Own posts response data = $postsData');

        // Parse directly like PostStore - no transformation needed
        final List<PostModel> newPosts =
            postsData.map((postJson) => PostModel.fromJson(postJson)).toList();

        debugPrint('✅ Own posts parsed: ${newPosts.length} posts');
        debugPrint('📝 Own post IDs: ${newPosts.map((p) => p.id).toList()}');

        ownPosts.addAll(newPosts);
        debugPrint('📈 Total own posts now: ${ownPosts.length}');
      } else {
        setError('Không có dữ liệu bài viết');
      }
    } catch (e) {
      setError('Lỗi khi tải bài viết của bạn: ${e.toString()}');
      debugPrint('ProfilePostStore Error loading own posts: $e');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }

  // Load user posts by userId (with loadMore capability)
  @action
  Future<bool> loadUserPosts({
    required String userId,
    bool refresh = false,
    bool loadMore = false,
    int limit = 10,
  }) async {
    try {
      if (loadMore && (isLoading || !hasMoreData || currentUserId == null)) {
        return false;
      }

      debugPrint('🔄 ProfilePostStore: Loading user posts for userId: $userId');
      debugPrint(
        '📄 Refresh: $refresh, LoadMore: $loadMore, Limit: $limit, CurrentPage: $currentPage',
      );

      if (refresh) {
        setRefreshing(true);
        userPosts.clear();
        currentPage = 1;
        hasMoreData = true;
        currentUserId = userId;
        // Clear own posts khi load user posts để tránh confusion
        ownPosts.clear();
      } else if (loadMore) {
        setLoading(true);
        currentPage++;
      } else {
        setLoading(true);
        userPosts.clear();
        currentPage = 1;
        hasMoreData = true;
        currentUserId = userId;
        // Clear own posts khi load user posts để tránh confusion
        ownPosts.clear();
      }

      clearError();

      final response = await _postService.findUserPosts(
        userId: userId,
        page: currentPage,
        limit: limit,
      );

      debugPrint('✅ API Response: $response');
      debugPrint('📊 Response type: ${response.runtimeType}');
      debugPrint('🔍 Response keys: ${response.keys.toList()}');

      if (response['posts'] != null) {
        debugPrint('🔄 Processing response data...');
        final List<dynamic> postsData = response['posts'];
        final List<PostModel> newPosts =
            postsData.map((postJson) => PostModel.fromJson(postJson)).toList();

        debugPrint('🆕 New posts mapped: ${newPosts.length}');
        debugPrint('📝 Post IDs: ${newPosts.map((p) => p.id).toList()}');

        if (refresh || !loadMore) {
          userPosts.clear();
        }
        userPosts.addAll(newPosts);

        debugPrint('📈 Total user posts now: ${userPosts.length}');

        // Check if there are more posts
        final int total = response['total'] ?? 0;
        hasMoreData = userPosts.length < total;
        currentUserId = userId;

        debugPrint('🔄 HasMoreData: $hasMoreData (${userPosts.length}/$total)');
      }
      return true;
    } catch (e) {
      setError(
        loadMore
            ? 'Lỗi khi tải thêm bài viết: ${e.toString()}'
            : 'Lỗi khi tải bài viết: ${e.toString()}',
      );
      debugPrint('Error loading user posts: $e');
      if (loadMore) {
        currentPage--; // Revert page increment on error
      }
      return false;
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }

  // Computed
  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get isEmpty => ownPosts.isEmpty && !isLoading;

  @computed
  bool get isUserPostsEmpty => userPosts.isEmpty && !isLoading;

  @computed
  List<PostModel> get currentPosts {
    // Return own posts for own profile, user posts for user profile
    if (currentUserId != null) {
      return userPosts;
    } else {
      return ownPosts;
    }
  }
}

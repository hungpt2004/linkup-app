import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/constants/routes/hive_path.dart';
import '../../../../data/models/post/post_model.dart';
import '../../../../data/models/post/link_model.dart';
import '../../../../data/models/post/hashtag_model.dart';
import '../../../../data/models/post/mention_model.dart';
import '../../../../data/models/user/user_model.dart';
import '../service/create_post_service.dart';
import 'audience_post_store.dart';
import 'tag_people_post_store.dart';
import '../../posts/store/post_store.dart';
import '../../../shared/extensions/model_convert_extension.dart';
import '../../../shared/extensions/hive_convert_extension.dart';
import '../../../../data/models/post/hive/post_model_hive.dart';
import '../../../shared/utils/hive_utils.dart';
import '../../home/store/network_status_checking_store.dart';

part 'create_post_store.g.dart';

// ignore: library_private_types_in_public_api
class CreatePostStore = _CreatePostStore with _$CreatePostStore;

abstract class _CreatePostStore with Store {
  final CreatePostService _createPostService = CreatePostService();

  // Khai báo hive_box và tên của hive_box
  static final String _hiveBoxName = HiveBoxName.offlinePost;
  late Box<PostModelHive> _offlinePostsBox;

  // Store dependencies
  AudienceStore? _audienceStore;
  TagUserStore? _tagUserStore;
  PostStore? _postStore;
  NetworkStatusStore? _networkStore;

  // MobX reaction disposer
  ReactionDisposer? _wifiReactionDisposer;

  // Constructor to inject dependencies
  void setStores(
    AudienceStore audienceStore,
    TagUserStore tagUserStore, [
    PostStore? postStore,
    NetworkStatusStore? networkStore,
  ]) {
    _audienceStore = audienceStore;
    _tagUserStore = tagUserStore;
    _postStore = postStore;
    _networkStore = networkStore;

    debugPrint('📋 CreatePostStore setStores called:');
    debugPrint('  - NetworkStore: ${_networkStore != null ? "✅" : "❌"}');
    debugPrint('  - PostStore: ${_postStore != null ? "✅" : "❌"}');
    debugPrint('  - Current WiFi: ${_networkStore?.isWifi ?? "unknown"}');

    // Initialize Hive open box local save
    _initHive();

    //
    _setupWifiReaction();
  }

  // Setup MobX reaction to listen for WiFi changes
  bool _isProcessingQueue = false;
  final Set<String> _processingPostIds =
      <String>{}; // Track posts being processed

  void _setupWifiReaction() {
    if (_networkStore == null) {
      debugPrint('⚠️ NetworkStore is null, cannot setup WiFi reaction');
      return;
    }

    debugPrint(
      '🎯 Setting up WiFi reaction - Initial WiFi: ${_networkStore!.isWifi}',
    );

    _wifiReactionDisposer = reaction((_) => _networkStore!.isWifi, (
      bool isWifi,
    ) async {
      debugPrint(
        '🔄 WiFi state changed: $isWifi, queue: ${postNeedWifi.length}, processing: $_isProcessingQueue',
      );

      // Tránh chạy đồng thời và chỉ chạy khi có WiFi + có posts trong queue + không đang xử lý
      if (isWifi && postNeedWifi.isNotEmpty && !_isProcessingQueue) {
        _isProcessingQueue = true;
        try {
          await postQueuedPostsWhenOnline();
          // Không cần sync lại vì posts đã được thêm vào list trong postQueuedPostsWhenOnline()
          debugPrint('🔄 Queue processing completed, no refresh needed');
        } catch (e) {
          debugPrint('❌ Error in WiFi reaction: $e');
        } finally {
          _isProcessingQueue = false;
        }
      }
    });
  }

  // Initialize Hive box
  Future<void> _initHive() async {
    // Open box save offline post
    _offlinePostsBox = await HiveUtils.openBoxSafely<PostModelHive>(
      _hiveBoxName,
    );
    await _loadOfflinePostsFromHive();
  }

  // Load offline posts from Hive storage
  Future<void> _loadOfflinePostsFromHive() async {
    final List<PostModelHive> savedPosts = _offlinePostsBox.values.toList();
    postNeedWifi.clear();
    postNeedWifi.addAll(savedPosts.map((post) => post.toPostModel()).toList());
  }

  // Save offline posts to Hive storage
  Future<void> _saveOfflinePostsToHive() async {
    try {
      // ignore: unnecessary_type_check
      if (_offlinePostsBox is! Box<PostModelHive>) {
        await _offlinePostsBox.close();
        _offlinePostsBox = await HiveUtils.openBoxSafely<PostModelHive>(
          _hiveBoxName,
        );
      }

      // Clear the box first
      await _offlinePostsBox.clear();

      // Save all current offline posts
      for (int i = 0; i < postNeedWifi.length; i++) {
        await _offlinePostsBox.putAt(i, postNeedWifi[i].toPostModelHive());
      }
    } catch (e) {
      debugPrint('Error saving offline posts to Hive: $e');
    }
  }

  // Observable states
  @observable
  bool isLoading = false;

  @observable
  bool isUploading = false;

  @observable
  String? errorMessage;

  @observable
  String caption = '';

  // Làm bị thừa logic
  // TODO: Cần xóa refactor
  @observable
  ObservableList<PostModel> posts = ObservableList();

  // Media files
  @observable
  ObservableList<String> selectedImagePaths = ObservableList<String>();

  @observable
  ObservableList<String> selectedVideoPaths = ObservableList<String>();

  @observable
  ObservableList<String> uploadedImageUrls = ObservableList<String>();

  @observable
  ObservableList<String> uploadedVideoUrls = ObservableList<String>();

  @observable
  bool isMicEnabled = false;

  @observable
  bool isAIGenCaptionEnabled = false;

  @observable
  bool isAIGenImageEnabled = false;

  // AI Caption sub-options
  @observable
  bool aiCaptionAutoCorrect = false;

  @observable
  bool aiCaptionAddHashtags = false;

  @observable
  bool aiCaptionTranslate = false;

  // AI Image sub-options
  @observable
  bool aiImageEnhanceQuality = false;

  @observable
  bool aiImageAddFilters = false;

  @observable
  bool aiImageAutoResize = false;

  @observable
  ObservableList<LinkModel> links = ObservableList<LinkModel>();

  @observable
  ObservableList<String> hashtags = ObservableList<String>();

  @observable
  ObservableList<String> mentions = ObservableList<String>();

  // Lưu danh sách post cần wifi
  @observable
  ObservableList<PostModel> postNeedWifi = ObservableList<PostModel>();

  // In-memory draft storage (simple, survives while app runs)
  @observable
  Map<String, dynamic>? draft;

  // Selected users for mentions
  @observable
  ObservableList<dynamic> selectedUsers = ObservableList<dynamic>();

  // Actions
  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setUploading(bool value) {
    isUploading = value;
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
  void setCaption(String value) {
    caption = value;
  }

  // AI and Microphone settings actions
  @action
  void setMicEnabled(bool enabled) {
    isMicEnabled = enabled;
  }

  @action
  void setAIGenCaptionEnabled(bool enabled) {
    isAIGenCaptionEnabled = enabled;
    // Reset sub-options when disabled
    if (!enabled) {
      aiCaptionAutoCorrect = false;
      aiCaptionAddHashtags = false;
      aiCaptionTranslate = false;
    }
  }

  @action
  void setAIGenImageEnabled(bool enabled) {
    isAIGenImageEnabled = enabled;
    // Reset sub-options when disabled
    if (!enabled) {
      aiImageEnhanceQuality = false;
      aiImageAddFilters = false;
      aiImageAutoResize = false;
    }
  }

  // AI Caption sub-options actions
  @action
  void setAICaptionAutoCorrect(bool enabled) {
    aiCaptionAutoCorrect = enabled;
  }

  @action
  void setAICaptionAddHashtags(bool enabled) {
    aiCaptionAddHashtags = enabled;
  }

  @action
  void setAICaptionTranslate(bool enabled) {
    aiCaptionTranslate = enabled;
  }

  // AI Image sub-options actions
  @action
  void setAIImageEnhanceQuality(bool enabled) {
    aiImageEnhanceQuality = enabled;
  }

  @action
  void setAIImageAddFilters(bool enabled) {
    aiImageAddFilters = enabled;
  }

  @action
  void setAIImageAutoResize(bool enabled) {
    aiImageAutoResize = enabled;
  }

  // Media management
  @action
  void addImagePath(String path) {
    selectedImagePaths.add(path);
  }

  @action
  void removeImagePath(int index) {
    if (index >= 0 && index < selectedImagePaths.length) {
      selectedImagePaths.removeAt(index);
    }
  }

  @action
  void addVideoPath(String path) {
    selectedVideoPaths.add(path);
  }

  @action
  void removeVideoPath(int index) {
    if (index >= 0 && index < selectedVideoPaths.length) {
      selectedVideoPaths.removeAt(index);
    }
  }

  @action
  void clearSelectedMedia() {
    selectedImagePaths.clear();
    selectedVideoPaths.clear();
    uploadedImageUrls.clear();
    uploadedVideoUrls.clear();
  }

  @action
  void clearSelectedImages() {
    selectedImagePaths.clear();
    uploadedImageUrls.clear();
  }

  @action
  void clearSelectedVideos() {
    selectedVideoPaths.clear();
    uploadedVideoUrls.clear();
  }

  @action
  void clearSelectedUsers() {
    selectedUsers.clear();
    mentions.clear();
  }

  @action
  void clearAll() {
    caption = '';
    selectedImagePaths.clear();
    selectedVideoPaths.clear();
    uploadedImageUrls.clear();
    uploadedVideoUrls.clear();
    selectedUsers.clear();
    mentions.clear();
    hashtags.clear();
    links.clear();
    errorMessage = null;
    // Reset AI and microphone settings
    isMicEnabled = false;
    isAIGenCaptionEnabled = false;
    isAIGenImageEnabled = false;
    // Reset AI sub-options
    aiCaptionAutoCorrect = false;
    aiCaptionAddHashtags = false;
    aiCaptionTranslate = false;
    aiImageEnhanceQuality = false;
    aiImageAddFilters = false;
    aiImageAutoResize = false;
  }

  // Add hashtags and mentions
  @action
  void addHashtag(String tag) {
    if (!hashtags.contains(tag)) {
      hashtags.add(tag);
    }
  }

  @action
  void removeHashtag(String tag) {
    hashtags.remove(tag);
  }

  @action
  void addMention(String mention) {
    if (!mentions.contains(mention)) {
      mentions.add(mention);
    }
  }

  @action
  void removeMention(String mention) {
    mentions.remove(mention);
  }

  @action
  void addLink(LinkModel link) {
    if (!links.any((l) => l.url == link.url)) {
      links.add(link);
    }
  }

  @action
  void removeLink(String url) {
    links.removeWhere((l) => l.url == url);
  }

  @action
  void setLinks(List<LinkModel> linkList) {
    links
      ..clear()
      ..addAll(linkList);
  }

  @action
  void setHashtags(List<String> hashtags) {
    this.hashtags
      ..clear()
      ..addAll(hashtags);
  }

  @action
  Future<void> saveDraft() async {
    draft = {
      'caption': caption,
      'images': selectedImagePaths.toList(),
      'videos': selectedVideoPaths.toList(),
      'links': links.map((l) => l.toJson()).toList(),
      'hashtags': hashtags.toList(),
      'mentions': mentions.toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @action
  void clearDraft() {
    draft = null;
  }

  @action
  Future<bool> checkPostNeedWifi(String postId) async {
    if (postNeedWifi.isEmpty) {
      return false;
    }
    return postNeedWifi.any((item) => item.id == postId);
  }

  // Method to remove a queued post (e.g., when user discards it)
  @action
  void removeQueuedPost(String postId) {
    final initialCount = postNeedWifi.length;
    postNeedWifi.removeWhere((post) => post.id == postId);
    final finalCount = postNeedWifi.length;

    debugPrint(
      '🗑️ removeQueuedPost called for $postId - Queue: $initialCount → $finalCount',
    );
    if (initialCount != finalCount) {
      _saveOfflinePostsToHive();
    }
  }

  // Method to post all queued posts when WiFi becomes available
  @action
  Future<void> postQueuedPostsWhenOnline() async {
    if (postNeedWifi.isEmpty || _isProcessingQueue) {
      debugPrint(
        '⏭️ Skipping queue processing - empty: ${postNeedWifi.isEmpty}, processing: $_isProcessingQueue',
      );
      return;
    }

    debugPrint('🚀 Starting to post ${postNeedWifi.length} queued posts');

    // Tạo snapshot của IDs để tránh concurrent modification
    final queuedPostIds = postNeedWifi.map((post) => post.id).toSet();
    final successfulIds = <String>[];
    final failedIds = <String>[];

    for (final postId in queuedPostIds) {
      // Kiểm tra xem post có đang được xử lý không
      if (_processingPostIds.contains(postId)) {
        debugPrint('⚠️ Post $postId is already being processed, skipping');
        continue;
      }

      // Tìm post trong list hiện tại (có thể đã bị thay đổi)
      final post = postNeedWifi.where((p) => p.id == postId).firstOrNull;
      if (post == null) {
        debugPrint('⚠️ Post $postId no longer in queue, skipping');
        continue;
      }

      // Đánh dấu là đang xử lý
      _processingPostIds.add(postId);

      debugPrint(
        '📤 Posting: ${post.id} - "${post.caption.substring(0, post.caption.length > 30 ? 30 : post.caption.length)}"...',
      );

      try {
        final response = await _createPostService.createPost(
          caption: post.caption,
          imagePaths: post.images,
          videoPaths: post.videos,
          links: post.links.map((e) => e.toJson()).toList(),
          hashtags: post.hashtags.map((e) => e.name).toList(),
          mentions: post.mentions.map((e) => e.id).toList(),
          privacy: post.privacy,
        );

        if (response['result'] != null) {
          debugPrint('✅ Successfully posted: ${post.id}');
          successfulIds.add(post.id);

          // Add to main posts list and remove the offline version
          if (_postStore != null) {
            final newPost = PostModel.fromJson(response['result']);
            // Remove the offline post from the main list
            _postStore!.posts.removeWhere((item) => item.id == post.id);
            // Add the new online post at the beginning
            _postStore!.posts.insert(0, newPost);

            // Also add to local posts list
            posts.removeWhere((item) => item.id == post.id);
            posts.insert(0, newPost);

            debugPrint(
              '🔄 Replaced offline post ${post.id} with online post ${newPost.id}',
            );
          }
        } else {
          debugPrint('❌ Failed to post ${post.id}: No result in response');
          failedIds.add(post.id);
        }
      } catch (e, stackTrace) {
        debugPrint('💥 Error posting ${post.id}: $e');
        debugPrint('Stack trace: $stackTrace');
        failedIds.add(post.id);
      } finally {
        // Luôn remove khỏi processing set
        _processingPostIds.remove(postId);
      }
    }

    // Xóa tất cả posts thành công bằng cách sử dụng removeQueuedPost
    if (successfulIds.isNotEmpty) {
      debugPrint(
        '🗑️ Removing ${successfulIds.length} successful posts from queue',
      );
      for (final postId in successfulIds) {
        removeQueuedPost(postId);
      }
    }

    // Cleanup processing set
    _processingPostIds.clear();

    debugPrint(
      '🏁 Finished processing queue - Success: ${successfulIds.length}, Failed: ${failedIds.length}, Remaining: ${postNeedWifi.length}',
    );
  }

  // Create post
  @action
  Future<bool> createPost(
    bool isWifi,
    Map<String, dynamic>? currentUser, [
    Map<String, dynamic>? postData,
  ]) async {
    debugPrint('CreatePostStore.createPost called with isWifi: $isWifi');

    try {
      setLoading(true);
      clearError();

      final content = postData?['content'] ?? caption;

      // Kiểm tra có content hoặc có media
      if (content.trim().isEmpty && !hasMedia) {
        setError('Vui lòng nhập nội dung hoặc chọn ảnh/video');
        return false;
      }

      String postPrivacy =
          _audienceStore?.typeAudience.toLowerCase() ?? 'public';

      // Chuẩn bị danh sách hashtag thực tế (nếu backend cần id thì map sang id)
      List<String> hashtagList = hashtags.toList();
      List<String> postMentions = [];

      // Get user IDs for mentions from TagUserStore
      if (_tagUserStore != null &&
          _tagUserStore!.selectedUserInfor.isNotEmpty) {
        for (var user in _tagUserStore!.selectedUserInfor) {
          if (user.id != null) {
            postMentions.add(user.id!);
          }
        }
      }

      // Also include any existing mentions
      postMentions.addAll(mentions);

      // If not connected to WiFi, queue the post for later submission
      if (isWifi == false) {
        debugPrint('Creating offline post');
        final authorId = postData?['author'] ?? '';
        final tempPost = PostModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          caption: content,
          images: selectedImagePaths.toList(),
          videos: selectedVideoPaths.toList(),
          links: links.toList(),
          author: authorId ?? '',
          hashtags:
              hashtagList
                  .map((tag) => HashtagModel(id: '', name: tag))
                  .toList(),
          mentions:
              postMentions
                  .map(
                    (mention) => MentionModel(id: mention, name: '', email: ''),
                  )
                  .toList(),
          privacy: postPrivacy,
          comments: 0,
          user: UserModel(
            id: currentUser?['_id'] ?? 'unknown_id',
            name:
                currentUser?['fullname'] ??
                currentUser?['name'] ??
                'unknown_name',
            email: currentUser?['email'] ?? 'unknown@example.com',
            verified: currentUser?['isVerified'] ?? false,
            role:
                currentUser?['role'] == 'admin'
                    ? UserRole.admin
                    : UserRole.user,
            avatarUrl: currentUser?['avatar'],
            numberFriends: currentUser?['numberFriends'] ?? 0,
            coverImageUrl: currentUser?['background'],
            createdAt:
                currentUser?['createdAt'] != null
                    ? DateTime.parse(currentUser!['createdAt'])
                    : null,
            updatedAt:
                currentUser?['updatedAt'] != null
                    ? DateTime.parse(currentUser!['updatedAt'])
                    : null,
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          likeCount: 0,
          listUsers: [],
        );

        // Thêm post vào list post_need_wifi
        postNeedWifi.add(tempPost);
        debugPrint(
          '📥 Added offline post to queue: ${tempPost.id} - Queue size: ${postNeedWifi.length}',
        );

        // Thêm bài post offline cached vào
        _saveOfflinePostsToHive();

        // Add to main posts list so it appears in the feed with overlay
        // QUAN TRỌNG: Chỉ add khi chưa có trong list
        if (_postStore != null) {
          final existingIndex = _postStore!.posts.indexWhere(
            (p) => p.id == tempPost.id,
          );
          if (existingIndex == -1) {
            _postStore!.posts.insert(0, tempPost);
            debugPrint('Added offline post to UI: ${tempPost.id}');
          }
        }

        // Clear the form
        caption = '';
        selectedImagePaths.clear();
        selectedVideoPaths.clear();
        uploadedImageUrls.clear();
        uploadedVideoUrls.clear();
        selectedUsers.clear();
        mentions.clear();
        links.clear();
        hashtags.clear();

        setError('Post queued for when WiFi is available');
        return true; // Still return true to indicate the operation was successful
      }

      debugPrint('Creating online post');
      final response = await _createPostService.createPost(
        caption: content,
        imagePaths: selectedImagePaths.toList(),
        videoPaths: selectedVideoPaths.toList(),
        links: links.whereType<LinkModel>().map((e) => e.toJson()).toList(),
        hashtags: hashtagList,
        mentions: postMentions,
        privacy: postPrivacy,
      );

      final isSuccess = response['result'] != null;

      if (isSuccess) {
        if (_postStore != null && response['result'] != null) {
          final newPost = PostModel.fromJson(response['result']);
          _postStore!.posts.insert(0, newPost);
        }
        return true;
      } else {
        setError(response['message'] ?? 'Không thể tạo bài viết');
        return false;
      }
    } catch (e) {
      setError('Lỗi khi tạo bài viết: ${e.toString()}');
      return false;
    } finally {
      Future.delayed(Duration(seconds: 2));
    }
  }

  // Reset form
  @action
  void resetForm() {
    caption = '';
    clearSelectedMedia();
    hashtags.clear();
    mentions.clear();
    links.clear();
    clearError();
    // Reset AI and microphone settings
    isMicEnabled = false;
    isAIGenCaptionEnabled = false;
    isAIGenImageEnabled = false;
    // Reset AI sub-options
    aiCaptionAutoCorrect = false;
    aiCaptionAddHashtags = false;
    aiCaptionTranslate = false;
    aiImageEnhanceQuality = false;
    aiImageAddFilters = false;
    aiImageAutoResize = false;
  }

  // Computed values
  @computed
  bool get hasMedia =>
      selectedImagePaths.isNotEmpty || selectedVideoPaths.isNotEmpty;

  @computed
  bool get canPost {
    final result =
        (caption.trim().isNotEmpty || hasMedia) && !isLoading && !isUploading;
    return result;
  }

  @computed
  int get totalMediaCount =>
      selectedImagePaths.length + selectedVideoPaths.length;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  String get currentPrivacy =>
      _audienceStore?.typeAudience.toLowerCase() ?? 'public';

  @computed
  List<String> get currentMentions {
    List<String> allMentions = [];
    if (_tagUserStore != null && _tagUserStore!.selectedUserInfor.isNotEmpty) {
      for (var user in _tagUserStore!.selectedUserInfor) {
        if (user.id != null) {
          allMentions.add(user.id!);
        }
      }
    }
    allMentions.addAll(mentions);
    return allMentions;
  }

  // Method to sync posts after network reconnection
  @action
  Future<void> syncPostsAfterReconnection() async {
    if (_postStore != null) {
      await _postStore!.refresh();
    }
  }

  @computed
  String get aiStatusText {
    if (isAIGenCaptionEnabled && isAIGenImageEnabled) {
      return 'Text + Image';
    } else if (isAIGenCaptionEnabled) {
      return 'Text';
    } else if (isAIGenImageEnabled) {
      return 'Image';
    } else {
      return 'Off';
    }
  }

  @computed
  String get micStatusText {
    return isMicEnabled ? 'On' : 'Off';
  }

  // Dispose method to clean up resources
  void dispose() {
    try {
      // 1. Dispose MobX reaction
      _wifiReactionDisposer?.call();
      _wifiReactionDisposer = null;

      // 2. Close Hive box to prevent memory leaks
      if (_offlinePostsBox.isOpen) {
        _offlinePostsBox.close();
      }

      // 3. Clear processing states
      _isProcessingQueue = false;
      _processingPostIds.clear();

      // 4. Clear all observable lists
      postNeedWifi.clear();
      posts.clear();
      selectedImagePaths.clear();
      selectedVideoPaths.clear();
      uploadedImageUrls.clear();
      uploadedVideoUrls.clear();
      links.clear();
      hashtags.clear();
      mentions.clear();
      selectedUsers.clear();

      debugPrint('✅ CreatePostStore disposed successfully');
    } catch (e) {
      debugPrint('❌ Error disposing CreatePostStore: $e');
    }
  }
}

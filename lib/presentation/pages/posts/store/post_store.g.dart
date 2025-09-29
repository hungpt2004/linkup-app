// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostStore on _PostStore, Store {
  Computed<int>? _$postsCountComputed;

  @override
  int get postsCount => (_$postsCountComputed ??=
          Computed<int>(() => super.postsCount, name: '_PostStore.postsCount'))
      .value;
  Computed<int>? _$storiesCountComputed;

  @override
  int get storiesCount =>
      (_$storiesCountComputed ??= Computed<int>(() => super.storiesCount,
              name: '_PostStore.storiesCount'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??=
          Computed<bool>(() => super.hasError, name: '_PostStore.hasError'))
      .value;
  Computed<int>? _$selectedUsersCountComputed;

  @override
  int get selectedUsersCount => (_$selectedUsersCountComputed ??= Computed<int>(
          () => super.selectedUsersCount,
          name: '_PostStore.selectedUsersCount'))
      .value;
  Computed<bool>? _$hasSelectedUsersComputed;

  @override
  bool get hasSelectedUsers => (_$hasSelectedUsersComputed ??= Computed<bool>(
          () => super.hasSelectedUsers,
          name: '_PostStore.hasSelectedUsers'))
      .value;
  Computed<List<UserEntity>>? _$filteredShareUsersComputed;

  @override
  List<UserEntity> get filteredShareUsers => (_$filteredShareUsersComputed ??=
          Computed<List<UserEntity>>(() => super.filteredShareUsers,
              name: '_PostStore.filteredShareUsers'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: '_PostStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isInitializingAtom =
      Atom(name: '_PostStore.isInitializing', context: context);

  @override
  bool get isInitializing {
    _$isInitializingAtom.reportRead();
    return super.isInitializing;
  }

  @override
  set isInitializing(bool value) {
    _$isInitializingAtom.reportWrite(value, super.isInitializing, () {
      super.isInitializing = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_PostStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$commentInputAtom =
      Atom(name: '_PostStore.commentInput', context: context);

  @override
  String get commentInput {
    _$commentInputAtom.reportRead();
    return super.commentInput;
  }

  @override
  set commentInput(String value) {
    _$commentInputAtom.reportWrite(value, super.commentInput, () {
      super.commentInput = value;
    });
  }

  late final _$replyToUserAtom =
      Atom(name: '_PostStore.replyToUser', context: context);

  @override
  String get replyToUser {
    _$replyToUserAtom.reportRead();
    return super.replyToUser;
  }

  @override
  set replyToUser(String value) {
    _$replyToUserAtom.reportWrite(value, super.replyToUser, () {
      super.replyToUser = value;
    });
  }

  late final _$parentCommentIdAtom =
      Atom(name: '_PostStore.parentCommentId', context: context);

  @override
  String get parentCommentId {
    _$parentCommentIdAtom.reportRead();
    return super.parentCommentId;
  }

  @override
  set parentCommentId(String value) {
    _$parentCommentIdAtom.reportWrite(value, super.parentCommentId, () {
      super.parentCommentId = value;
    });
  }

  late final _$postsAtom = Atom(name: '_PostStore.posts', context: context);

  @override
  ObservableList<PostModel> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<PostModel> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$cachedPostsAtom =
      Atom(name: '_PostStore.cachedPosts', context: context);

  @override
  ObservableList<PostModel> get cachedPosts {
    _$cachedPostsAtom.reportRead();
    return super.cachedPosts;
  }

  @override
  set cachedPosts(ObservableList<PostModel> value) {
    _$cachedPostsAtom.reportWrite(value, super.cachedPosts, () {
      super.cachedPosts = value;
    });
  }

  late final _$storiesAtom = Atom(name: '_PostStore.stories', context: context);

  @override
  ObservableList<Map<String, dynamic>> get stories {
    _$storiesAtom.reportRead();
    return super.stories;
  }

  @override
  set stories(ObservableList<Map<String, dynamic>> value) {
    _$storiesAtom.reportWrite(value, super.stories, () {
      super.stories = value;
    });
  }

  late final _$isRefreshingAtom =
      Atom(name: '_PostStore.isRefreshing', context: context);

  @override
  bool get isRefreshing {
    _$isRefreshingAtom.reportRead();
    return super.isRefreshing;
  }

  @override
  set isRefreshing(bool value) {
    _$isRefreshingAtom.reportWrite(value, super.isRefreshing, () {
      super.isRefreshing = value;
    });
  }

  late final _$isLoadMoreAtom =
      Atom(name: '_PostStore.isLoadMore', context: context);

  @override
  bool get isLoadMore {
    _$isLoadMoreAtom.reportRead();
    return super.isLoadMore;
  }

  @override
  set isLoadMore(bool value) {
    _$isLoadMoreAtom.reportWrite(value, super.isLoadMore, () {
      super.isLoadMore = value;
    });
  }

  late final _$hasMorePostsAtom =
      Atom(name: '_PostStore.hasMorePosts', context: context);

  @override
  bool get hasMorePosts {
    _$hasMorePostsAtom.reportRead();
    return super.hasMorePosts;
  }

  @override
  set hasMorePosts(bool value) {
    _$hasMorePostsAtom.reportWrite(value, super.hasMorePosts, () {
      super.hasMorePosts = value;
    });
  }

  late final _$isPreviewLinkAtom =
      Atom(name: '_PostStore.isPreviewLink', context: context);

  @override
  bool get isPreviewLink {
    _$isPreviewLinkAtom.reportRead();
    return super.isPreviewLink;
  }

  @override
  set isPreviewLink(bool value) {
    _$isPreviewLinkAtom.reportWrite(value, super.isPreviewLink, () {
      super.isPreviewLink = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_PostStore.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$friendsOnlyAtom =
      Atom(name: '_PostStore.friendsOnly', context: context);

  @override
  bool get friendsOnly {
    _$friendsOnlyAtom.reportRead();
    return super.friendsOnly;
  }

  @override
  set friendsOnly(bool value) {
    _$friendsOnlyAtom.reportWrite(value, super.friendsOnly, () {
      super.friendsOnly = value;
    });
  }

  late final _$isLoadedFromCacheAtom =
      Atom(name: '_PostStore.isLoadedFromCache', context: context);

  @override
  bool get isLoadedFromCache {
    _$isLoadedFromCacheAtom.reportRead();
    return super.isLoadedFromCache;
  }

  @override
  set isLoadedFromCache(bool value) {
    _$isLoadedFromCacheAtom.reportWrite(value, super.isLoadedFromCache, () {
      super.isLoadedFromCache = value;
    });
  }

  late final _$shareUserListsAtom =
      Atom(name: '_PostStore.shareUserLists', context: context);

  @override
  ObservableList<UserEntity> get shareUserLists {
    _$shareUserListsAtom.reportRead();
    return super.shareUserLists;
  }

  @override
  set shareUserLists(ObservableList<UserEntity> value) {
    _$shareUserListsAtom.reportWrite(value, super.shareUserLists, () {
      super.shareUserLists = value;
    });
  }

  late final _$selectedUsersMapAtom =
      Atom(name: '_PostStore.selectedUsersMap', context: context);

  @override
  ObservableMap<String, bool> get selectedUsersMap {
    _$selectedUsersMapAtom.reportRead();
    return super.selectedUsersMap;
  }

  @override
  set selectedUsersMap(ObservableMap<String, bool> value) {
    _$selectedUsersMapAtom.reportWrite(value, super.selectedUsersMap, () {
      super.selectedUsersMap = value;
    });
  }

  late final _$shareSearchQueryAtom =
      Atom(name: '_PostStore.shareSearchQuery', context: context);

  @override
  String get shareSearchQuery {
    _$shareSearchQueryAtom.reportRead();
    return super.shareSearchQuery;
  }

  @override
  set shareSearchQuery(String value) {
    _$shareSearchQueryAtom.reportWrite(value, super.shareSearchQuery, () {
      super.shareSearchQuery = value;
    });
  }

  late final _$listLikeUsersAtom =
      Atom(name: '_PostStore.listLikeUsers', context: context);

  @override
  ObservableMap<String, List<LikeModel>> get listLikeUsers {
    _$listLikeUsersAtom.reportRead();
    return super.listLikeUsers;
  }

  @override
  set listLikeUsers(ObservableMap<String, List<LikeModel>> value) {
    _$listLikeUsersAtom.reportWrite(value, super.listLikeUsers, () {
      super.listLikeUsers = value;
    });
  }

  late final _$likeCountAtom =
      Atom(name: '_PostStore.likeCount', context: context);

  @override
  ObservableMap<String, int> get likeCount {
    _$likeCountAtom.reportRead();
    return super.likeCount;
  }

  @override
  set likeCount(ObservableMap<String, int> value) {
    _$likeCountAtom.reportWrite(value, super.likeCount, () {
      super.likeCount = value;
    });
  }

  late final _$mapReactionByTypeAtom =
      Atom(name: '_PostStore.mapReactionByType', context: context);

  @override
  ObservableMap<String, List<LikeModel>> get mapReactionByType {
    _$mapReactionByTypeAtom.reportRead();
    return super.mapReactionByType;
  }

  @override
  set mapReactionByType(ObservableMap<String, List<LikeModel>> value) {
    _$mapReactionByTypeAtom.reportWrite(value, super.mapReactionByType, () {
      super.mapReactionByType = value;
    });
  }

  late final _$postDetailAtom =
      Atom(name: '_PostStore.postDetail', context: context);

  @override
  PostModel? get postDetail {
    _$postDetailAtom.reportRead();
    return super.postDetail;
  }

  @override
  set postDetail(PostModel? value) {
    _$postDetailAtom.reportWrite(value, super.postDetail, () {
      super.postDetail = value;
    });
  }

  late final _$listCommentsAtom =
      Atom(name: '_PostStore.listComments', context: context);

  @override
  ObservableList<CommentModel> get listComments {
    _$listCommentsAtom.reportRead();
    return super.listComments;
  }

  @override
  set listComments(ObservableList<CommentModel> value) {
    _$listCommentsAtom.reportWrite(value, super.listComments, () {
      super.listComments = value;
    });
  }

  late final _$mapPostCommentsAtom =
      Atom(name: '_PostStore.mapPostComments', context: context);

  @override
  ObservableMap<String, List<CommentModel>> get mapPostComments {
    _$mapPostCommentsAtom.reportRead();
    return super.mapPostComments;
  }

  @override
  set mapPostComments(ObservableMap<String, List<CommentModel>> value) {
    _$mapPostCommentsAtom.reportWrite(value, super.mapPostComments, () {
      super.mapPostComments = value;
    });
  }

  late final _$mapCommentWithChildCommentsAtom =
      Atom(name: '_PostStore.mapCommentWithChildComments', context: context);

  @override
  ObservableMap<String, List<CommentModel>> get mapCommentWithChildComments {
    _$mapCommentWithChildCommentsAtom.reportRead();
    return super.mapCommentWithChildComments;
  }

  @override
  set mapCommentWithChildComments(
      ObservableMap<String, List<CommentModel>> value) {
    _$mapCommentWithChildCommentsAtom
        .reportWrite(value, super.mapCommentWithChildComments, () {
      super.mapCommentWithChildComments = value;
    });
  }

  late final _$toggleFriendsFilterAsyncAction =
      AsyncAction('_PostStore.toggleFriendsFilter', context: context);

  @override
  Future<void> toggleFriendsFilter() {
    return _$toggleFriendsFilterAsyncAction
        .run(() => super.toggleFriendsFilter());
  }

  late final _$loadPostsAsyncAction =
      AsyncAction('_PostStore.loadPosts', context: context);

  @override
  Future<void> loadPosts({bool refresh = false}) {
    return _$loadPostsAsyncAction.run(() => super.loadPosts(refresh: refresh));
  }

  late final _$cacheTopPostsToHiveAsyncAction =
      AsyncAction('_PostStore.cacheTopPostsToHive', context: context);

  @override
  Future<void> cacheTopPostsToHive() {
    return _$cacheTopPostsToHiveAsyncAction
        .run(() => super.cacheTopPostsToHive());
  }

  late final _$loadPostsFromHiveAsyncAction =
      AsyncAction('_PostStore.loadPostsFromHive', context: context);

  @override
  Future<void> loadPostsFromHive() {
    return _$loadPostsFromHiveAsyncAction.run(() => super.loadPostsFromHive());
  }

  late final _$_loadOfflinePostsIntoFeedAsyncAction =
      AsyncAction('_PostStore._loadOfflinePostsIntoFeed', context: context);

  @override
  Future<void> _loadOfflinePostsIntoFeed() {
    return _$_loadOfflinePostsIntoFeedAsyncAction
        .run(() => super._loadOfflinePostsIntoFeed());
  }

  late final _$toggleLikeAsyncAction =
      AsyncAction('_PostStore.toggleLike', context: context);

  @override
  Future<bool> toggleLike(String postId, String typeReact) {
    return _$toggleLikeAsyncAction
        .run(() => super.toggleLike(postId, typeReact));
  }

  late final _$toggleDislikeAsyncAction =
      AsyncAction('_PostStore.toggleDislike', context: context);

  @override
  Future<bool> toggleDislike(String postId) {
    return _$toggleDislikeAsyncAction.run(() => super.toggleDislike(postId));
  }

  late final _$loadPostDetailAsyncAction =
      AsyncAction('_PostStore.loadPostDetail', context: context);

  @override
  Future<bool> loadPostDetail(String id) {
    return _$loadPostDetailAsyncAction.run(() => super.loadPostDetail(id));
  }

  late final _$loadPostDetailSilentlyAsyncAction =
      AsyncAction('_PostStore.loadPostDetailSilently', context: context);

  @override
  Future<bool> loadPostDetailSilently(String id) {
    return _$loadPostDetailSilentlyAsyncAction
        .run(() => super.loadPostDetailSilently(id));
  }

  late final _$sharePostAsyncAction =
      AsyncAction('_PostStore.sharePost', context: context);

  @override
  Future<bool> sharePost(String postId) {
    return _$sharePostAsyncAction.run(() => super.sharePost(postId));
  }

  late final _$loadStoriesAsyncAction =
      AsyncAction('_PostStore.loadStories', context: context);

  @override
  Future<void> loadStories() {
    return _$loadStoriesAsyncAction.run(() => super.loadStories());
  }

  late final _$loadListCommentByPostAsyncAction =
      AsyncAction('_PostStore.loadListCommentByPost', context: context);

  @override
  Future<void> loadListCommentByPost(String postId) {
    return _$loadListCommentByPostAsyncAction
        .run(() => super.loadListCommentByPost(postId));
  }

  late final _$loadAndSaveChildCommentsAsyncAction =
      AsyncAction('_PostStore.loadAndSaveChildComments', context: context);

  @override
  Future<void> loadAndSaveChildComments(String parentCommentId) {
    return _$loadAndSaveChildCommentsAsyncAction
        .run(() => super.loadAndSaveChildComments(parentCommentId));
  }

  late final _$createNewCommentAsyncAction =
      AsyncAction('_PostStore.createNewComment', context: context);

  @override
  Future<bool> createNewComment(String postId, String text) {
    return _$createNewCommentAsyncAction
        .run(() => super.createNewComment(postId, text));
  }

  late final _$createChildCommentAsyncAction =
      AsyncAction('_PostStore.createChildComment', context: context);

  @override
  Future<bool> createChildComment(String postId, String parentId, String text) {
    return _$createChildCommentAsyncAction
        .run(() => super.createChildComment(postId, parentId, text));
  }

  late final _$updateCommentAsyncAction =
      AsyncAction('_PostStore.updateComment', context: context);

  @override
  Future<bool> updateComment(String text) {
    return _$updateCommentAsyncAction.run(() => super.updateComment(text));
  }

  late final _$deleteCommentAsyncAction =
      AsyncAction('_PostStore.deleteComment', context: context);

  @override
  Future<void> deleteComment(String commentId) {
    return _$deleteCommentAsyncAction.run(() => super.deleteComment(commentId));
  }

  late final _$updatePostAsyncAction =
      AsyncAction('_PostStore.updatePost', context: context);

  @override
  Future<bool> updatePost(String postId, Map<String, dynamic> postData) {
    return _$updatePostAsyncAction
        .run(() => super.updatePost(postId, postData));
  }

  late final _$deletePostAsyncAction =
      AsyncAction('_PostStore.deletePost', context: context);

  @override
  Future<bool> deletePost(String postId) {
    return _$deletePostAsyncAction.run(() => super.deletePost(postId));
  }

  late final _$getReactionByTypeReactAsyncAction =
      AsyncAction('_PostStore.getReactionByTypeReact', context: context);

  @override
  Future<void> getReactionByTypeReact(String postId, String typeReact) {
    return _$getReactionByTypeReactAsyncAction
        .run(() => super.getReactionByTypeReact(postId, typeReact));
  }

  late final _$initializeAsyncAction =
      AsyncAction('_PostStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$refreshPostDetailAndCommentsAsyncAction =
      AsyncAction('_PostStore.refreshPostDetailAndComments', context: context);

  @override
  Future<void> refreshPostDetailAndComments(String postId) {
    return _$refreshPostDetailAndCommentsAsyncAction
        .run(() => super.refreshPostDetailAndComments(postId));
  }

  late final _$loadMorePostsAsyncAction =
      AsyncAction('_PostStore.loadMorePosts', context: context);

  @override
  Future<void> loadMorePosts() {
    return _$loadMorePostsAsyncAction.run(() => super.loadMorePosts());
  }

  late final _$refreshAsyncAction =
      AsyncAction('_PostStore.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_PostStoreActionController =
      ActionController(name: '_PostStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInitializing(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setInitializing');
    try {
      return super.setInitializing(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setParentCommentId(String commentId) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setParentCommentId');
    try {
      return super.setParentCommentId(commentId);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFriendsOnly(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setFriendsOnly');
    try {
      return super.setFriendsOnly(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadedFromCache(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setLoadedFromCache');
    try {
      return super.setLoadedFromCache(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRefreshing(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setRefreshing');
    try {
      return super.setRefreshing(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsPreviewLink(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setIsPreviewLink');
    try {
      return super.setIsPreviewLink(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadMore(bool value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setLoadMore');
    try {
      return super.setLoadMore(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCommentInputValue(String value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setCommentInputValue');
    try {
      return super.setCommentInputValue(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReplyInputValue(String value) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setReplyInputValue');
    try {
      return super.setReplyInputValue(value);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCommentHaveReplyValue() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setCommentHaveReplyValue');
    try {
      return super.setCommentHaveReplyValue();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCommentInput() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.clearCommentInput');
    try {
      return super.clearCommentInput();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetCommentForm() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.resetCommentForm');
    try {
      return super.resetCommentForm();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.clear');
    try {
      return super.clear();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearShareUserLists() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.clearShareUserLists');
    try {
      return super.clearShareUserLists();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkUserExist(String userId) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.checkUserExist');
    try {
      return super.checkUserExist(userId);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOrRemoveShareUserList(UserEntity newUser) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.addOrRemoveShareUserList');
    try {
      return super.addOrRemoveShareUserList(newUser);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShareSearchQuery(String query) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.setShareSearchQuery');
    try {
      return super.setShareSearchQuery(query);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleUserSelection(UserEntity user) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.toggleUserSelection');
    try {
      return super.toggleUserSelection(user);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectAllUsers(List<UserEntity> users) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.selectAllUsers');
    try {
      return super.selectAllUsers(users);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void unselectAllUsers() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.unselectAllUsers');
    try {
      return super.unselectAllUsers();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearListComments() {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.clearListComments');
    try {
      return super.clearListComments();
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isInitializing: ${isInitializing},
errorMessage: ${errorMessage},
commentInput: ${commentInput},
replyToUser: ${replyToUser},
parentCommentId: ${parentCommentId},
posts: ${posts},
cachedPosts: ${cachedPosts},
stories: ${stories},
isRefreshing: ${isRefreshing},
isLoadMore: ${isLoadMore},
hasMorePosts: ${hasMorePosts},
isPreviewLink: ${isPreviewLink},
currentPage: ${currentPage},
friendsOnly: ${friendsOnly},
isLoadedFromCache: ${isLoadedFromCache},
shareUserLists: ${shareUserLists},
selectedUsersMap: ${selectedUsersMap},
shareSearchQuery: ${shareSearchQuery},
listLikeUsers: ${listLikeUsers},
likeCount: ${likeCount},
mapReactionByType: ${mapReactionByType},
postDetail: ${postDetail},
listComments: ${listComments},
mapPostComments: ${mapPostComments},
mapCommentWithChildComments: ${mapCommentWithChildComments},
postsCount: ${postsCount},
storiesCount: ${storiesCount},
hasError: ${hasError},
selectedUsersCount: ${selectedUsersCount},
hasSelectedUsers: ${hasSelectedUsers},
filteredShareUsers: ${filteredShareUsers}
    ''';
  }
}

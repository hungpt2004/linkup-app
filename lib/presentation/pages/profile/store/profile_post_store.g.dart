// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfilePostStore on _ProfilePostStore, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_ProfilePostStore.hasError'))
          .value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(() => super.isEmpty,
          name: '_ProfilePostStore.isEmpty'))
      .value;
  Computed<bool>? _$isUserPostsEmptyComputed;

  @override
  bool get isUserPostsEmpty => (_$isUserPostsEmptyComputed ??= Computed<bool>(
          () => super.isUserPostsEmpty,
          name: '_ProfilePostStore.isUserPostsEmpty'))
      .value;
  Computed<List<PostModel>>? _$currentPostsComputed;

  @override
  List<PostModel> get currentPosts => (_$currentPostsComputed ??=
          Computed<List<PostModel>>(() => super.currentPosts,
              name: '_ProfilePostStore.currentPosts'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: '_ProfilePostStore.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_ProfilePostStore.errorMessage', context: context);

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

  late final _$ownPostsAtom =
      Atom(name: '_ProfilePostStore.ownPosts', context: context);

  @override
  ObservableList<PostModel> get ownPosts {
    _$ownPostsAtom.reportRead();
    return super.ownPosts;
  }

  @override
  set ownPosts(ObservableList<PostModel> value) {
    _$ownPostsAtom.reportWrite(value, super.ownPosts, () {
      super.ownPosts = value;
    });
  }

  late final _$userPostsAtom =
      Atom(name: '_ProfilePostStore.userPosts', context: context);

  @override
  ObservableList<PostModel> get userPosts {
    _$userPostsAtom.reportRead();
    return super.userPosts;
  }

  @override
  set userPosts(ObservableList<PostModel> value) {
    _$userPostsAtom.reportWrite(value, super.userPosts, () {
      super.userPosts = value;
    });
  }

  late final _$isRefreshingAtom =
      Atom(name: '_ProfilePostStore.isRefreshing', context: context);

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

  late final _$currentPageAtom =
      Atom(name: '_ProfilePostStore.currentPage', context: context);

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

  late final _$hasMoreDataAtom =
      Atom(name: '_ProfilePostStore.hasMoreData', context: context);

  @override
  bool get hasMoreData {
    _$hasMoreDataAtom.reportRead();
    return super.hasMoreData;
  }

  @override
  set hasMoreData(bool value) {
    _$hasMoreDataAtom.reportWrite(value, super.hasMoreData, () {
      super.hasMoreData = value;
    });
  }

  late final _$currentUserIdAtom =
      Atom(name: '_ProfilePostStore.currentUserId', context: context);

  @override
  String? get currentUserId {
    _$currentUserIdAtom.reportRead();
    return super.currentUserId;
  }

  @override
  set currentUserId(String? value) {
    _$currentUserIdAtom.reportWrite(value, super.currentUserId, () {
      super.currentUserId = value;
    });
  }

  late final _$loadOwnPostsAsyncAction =
      AsyncAction('_ProfilePostStore.loadOwnPosts', context: context);

  @override
  Future<void> loadOwnPosts({bool refresh = false}) {
    return _$loadOwnPostsAsyncAction
        .run(() => super.loadOwnPosts(refresh: refresh));
  }

  late final _$loadUserPostsAsyncAction =
      AsyncAction('_ProfilePostStore.loadUserPosts', context: context);

  @override
  Future<bool> loadUserPosts(
      {required String userId,
      bool refresh = false,
      bool loadMore = false,
      int limit = 10}) {
    return _$loadUserPostsAsyncAction.run(() => super.loadUserPosts(
        userId: userId, refresh: refresh, loadMore: loadMore, limit: limit));
  }

  late final _$_ProfilePostStoreActionController =
      ActionController(name: '_ProfilePostStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_ProfilePostStoreActionController.startAction(
        name: '_ProfilePostStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_ProfilePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRefreshing(bool value) {
    final _$actionInfo = _$_ProfilePostStoreActionController.startAction(
        name: '_ProfilePostStore.setRefreshing');
    try {
      return super.setRefreshing(value);
    } finally {
      _$_ProfilePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_ProfilePostStoreActionController.startAction(
        name: '_ProfilePostStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_ProfilePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ProfilePostStoreActionController.startAction(
        name: '_ProfilePostStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ProfilePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAllPosts() {
    final _$actionInfo = _$_ProfilePostStoreActionController.startAction(
        name: '_ProfilePostStore.clearAllPosts');
    try {
      return super.clearAllPosts();
    } finally {
      _$_ProfilePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
ownPosts: ${ownPosts},
userPosts: ${userPosts},
isRefreshing: ${isRefreshing},
currentPage: ${currentPage},
hasMoreData: ${hasMoreData},
currentUserId: ${currentUserId},
hasError: ${hasError},
isEmpty: ${isEmpty},
isUserPostsEmpty: ${isUserPostsEmpty},
currentPosts: ${currentPosts}
    ''';
  }
}

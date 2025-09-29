// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendStore on _FriendStore, Store {
  Computed<int>? _$friendsCountComputed;

  @override
  int get friendsCount =>
      (_$friendsCountComputed ??= Computed<int>(() => super.friendsCount,
              name: '_FriendStore.friendsCount'))
          .value;
  Computed<int>? _$pendingRequestsCountComputed;

  @override
  int get pendingRequestsCount => (_$pendingRequestsCountComputed ??=
          Computed<int>(() => super.pendingRequestsCount,
              name: '_FriendStore.pendingRequestsCount'))
      .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??=
          Computed<bool>(() => super.hasError, name: '_FriendStore.hasError'))
      .value;

  late final _$followingAtom =
      Atom(name: '_FriendStore.following', context: context);

  @override
  ObservableList<UserModel> get following {
    _$followingAtom.reportRead();
    return super.following;
  }

  @override
  set following(ObservableList<UserModel> value) {
    _$followingAtom.reportWrite(value, super.following, () {
      super.following = value;
    });
  }

  late final _$unfriendedAtom =
      Atom(name: '_FriendStore.unfriended', context: context);

  @override
  ObservableList<UserModel> get unfriended {
    _$unfriendedAtom.reportRead();
    return super.unfriended;
  }

  @override
  set unfriended(ObservableList<UserModel> value) {
    _$unfriendedAtom.reportWrite(value, super.unfriended, () {
      super.unfriended = value;
    });
  }

  late final _$unfollowedAtom =
      Atom(name: '_FriendStore.unfollowed', context: context);

  @override
  ObservableList<UserModel> get unfollowed {
    _$unfollowedAtom.reportRead();
    return super.unfollowed;
  }

  @override
  set unfollowed(ObservableList<UserModel> value) {
    _$unfollowedAtom.reportWrite(value, super.unfollowed, () {
      super.unfollowed = value;
    });
  }

  late final _$followersAtom =
      Atom(name: '_FriendStore.followers', context: context);

  @override
  ObservableList<UserModel> get followers {
    _$followersAtom.reportRead();
    return super.followers;
  }

  @override
  set followers(ObservableList<UserModel> value) {
    _$followersAtom.reportWrite(value, super.followers, () {
      super.followers = value;
    });
  }

  late final _$statusAtom = Atom(name: '_FriendStore.status', context: context);

  @override
  String? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FriendStore.isLoading', context: context);

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
      Atom(name: '_FriendStore.errorMessage', context: context);

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

  late final _$successMessageAtom =
      Atom(name: '_FriendStore.successMessage', context: context);

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$friendsAtom =
      Atom(name: '_FriendStore.friends', context: context);

  @override
  ObservableList<UserModel> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableList<UserModel> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  late final _$sentRequestsAtom =
      Atom(name: '_FriendStore.sentRequests', context: context);

  @override
  ObservableList<FriendModel> get sentRequests {
    _$sentRequestsAtom.reportRead();
    return super.sentRequests;
  }

  @override
  set sentRequests(ObservableList<FriendModel> value) {
    _$sentRequestsAtom.reportWrite(value, super.sentRequests, () {
      super.sentRequests = value;
    });
  }

  late final _$historyRequestsAtom =
      Atom(name: '_FriendStore.historyRequests', context: context);

  @override
  ObservableList<UserModel> get historyRequests {
    _$historyRequestsAtom.reportRead();
    return super.historyRequests;
  }

  @override
  set historyRequests(ObservableList<UserModel> value) {
    _$historyRequestsAtom.reportWrite(value, super.historyRequests, () {
      super.historyRequests = value;
    });
  }

  late final _$friendRequestsTestAtom =
      Atom(name: '_FriendStore.friendRequestsTest', context: context);

  @override
  ObservableList<UserModel> get friendRequestsTest {
    _$friendRequestsTestAtom.reportRead();
    return super.friendRequestsTest;
  }

  @override
  set friendRequestsTest(ObservableList<UserModel> value) {
    _$friendRequestsTestAtom.reportWrite(value, super.friendRequestsTest, () {
      super.friendRequestsTest = value;
    });
  }

  late final _$saveSentRequestsAtom =
      Atom(name: '_FriendStore.saveSentRequests', context: context);

  @override
  ObservableList<String> get saveSentRequests {
    _$saveSentRequestsAtom.reportRead();
    return super.saveSentRequests;
  }

  @override
  set saveSentRequests(ObservableList<String> value) {
    _$saveSentRequestsAtom.reportWrite(value, super.saveSentRequests, () {
      super.saveSentRequests = value;
    });
  }

  late final _$suggestionsAtom =
      Atom(name: '_FriendStore.suggestions', context: context);

  @override
  ObservableList<Map<String, dynamic>> get suggestions {
    _$suggestionsAtom.reportRead();
    return super.suggestions;
  }

  @override
  set suggestions(ObservableList<Map<String, dynamic>> value) {
    _$suggestionsAtom.reportWrite(value, super.suggestions, () {
      super.suggestions = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_FriendStore.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$getMutualFriendsCountAsyncAction =
      AsyncAction('_FriendStore.getMutualFriendsCount', context: context);

  @override
  Future<Map<String, int>> getMutualFriendsCount(List<String> targetIds) {
    return _$getMutualFriendsCountAsyncAction
        .run(() => super.getMutualFriendsCount(targetIds));
  }

  late final _$getMutualFriendsAsyncAction =
      AsyncAction('_FriendStore.getMutualFriends', context: context);

  @override
  Future<Map<String, List<UserModel>>> getMutualFriends(
      List<String> targetIds) {
    return _$getMutualFriendsAsyncAction
        .run(() => super.getMutualFriends(targetIds));
  }

  late final _$followUserAsyncAction =
      AsyncAction('_FriendStore.followUser', context: context);

  @override
  Future<bool> followUser(String recipientId) {
    return _$followUserAsyncAction.run(() => super.followUser(recipientId));
  }

  late final _$unfollowUserAsyncAction =
      AsyncAction('_FriendStore.unfollowUser', context: context);

  @override
  Future<bool> unfollowUser(String recipientId) {
    return _$unfollowUserAsyncAction.run(() => super.unfollowUser(recipientId));
  }

  late final _$unfriendUserAsyncAction =
      AsyncAction('_FriendStore.unfriendUser', context: context);

  @override
  Future<bool> unfriendUser(String friendId) {
    return _$unfriendUserAsyncAction.run(() => super.unfriendUser(friendId));
  }

  late final _$sendFollowRequestAsyncAction =
      AsyncAction('_FriendStore.sendFollowRequest', context: context);

  @override
  Future<bool> sendFollowRequest(String recipientId) {
    return _$sendFollowRequestAsyncAction
        .run(() => super.sendFollowRequest(recipientId));
  }

  late final _$loadFollowersAsyncAction =
      AsyncAction('_FriendStore.loadFollowers', context: context);

  @override
  Future<bool> loadFollowers() {
    return _$loadFollowersAsyncAction.run(() => super.loadFollowers());
  }

  late final _$loadFriendsAsyncAction =
      AsyncAction('_FriendStore.loadFriends', context: context);

  @override
  Future<bool> loadFriends() {
    return _$loadFriendsAsyncAction.run(() => super.loadFriends());
  }

  late final _$loadFriendRequestsAsyncAction =
      AsyncAction('_FriendStore.loadFriendRequests', context: context);

  @override
  Future<bool> loadFriendRequests() {
    return _$loadFriendRequestsAsyncAction
        .run(() => super.loadFriendRequests());
  }

  late final _$acceptFriendRequestAsyncAction =
      AsyncAction('_FriendStore.acceptFriendRequest', context: context);

  @override
  Future<bool> acceptFriendRequest(String recipientId) {
    return _$acceptFriendRequestAsyncAction
        .run(() => super.acceptFriendRequest(recipientId));
  }

  late final _$rejectFriendRequestAsyncAction =
      AsyncAction('_FriendStore.rejectFriendRequest', context: context);

  @override
  Future<bool> rejectFriendRequest(String recipientId) {
    return _$rejectFriendRequestAsyncAction
        .run(() => super.rejectFriendRequest(recipientId));
  }

  late final _$sendFriendRequestAsyncAction =
      AsyncAction('_FriendStore.sendFriendRequest', context: context);

  @override
  Future<bool> sendFriendRequest(String recipientId) {
    return _$sendFriendRequestAsyncAction
        .run(() => super.sendFriendRequest(recipientId));
  }

  late final _$loadFollowingAsyncAction =
      AsyncAction('_FriendStore.loadFollowing', context: context);

  @override
  Future<bool> loadFollowing() {
    return _$loadFollowingAsyncAction.run(() => super.loadFollowing());
  }

  late final _$initializeAsyncAction =
      AsyncAction('_FriendStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$initializeFriendsAsyncAction =
      AsyncAction('_FriendStore.initializeFriends', context: context);

  @override
  Future<void> initializeFriends() {
    return _$initializeFriendsAsyncAction.run(() => super.initializeFriends());
  }

  late final _$_FriendStoreActionController =
      ActionController(name: '_FriendStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatus(String value) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setStatus');
    try {
      return super.setStatus(value);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSuccessMessage(String? value) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setSuccessMessage');
    try {
      return super.setSuccessMessage(value);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? value) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setErrorMessage');
    try {
      return super.setErrorMessage(value);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_FriendStoreActionController.startAction(
        name: '_FriendStore.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_FriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
following: ${following},
unfriended: ${unfriended},
unfollowed: ${unfollowed},
followers: ${followers},
status: ${status},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
friends: ${friends},
sentRequests: ${sentRequests},
historyRequests: ${historyRequests},
friendRequestsTest: ${friendRequestsTest},
saveSentRequests: ${saveSentRequests},
suggestions: ${suggestions},
searchQuery: ${searchQuery},
friendsCount: ${friendsCount},
pendingRequestsCount: ${pendingRequestsCount},
hasError: ${hasError}
    ''';
  }
}

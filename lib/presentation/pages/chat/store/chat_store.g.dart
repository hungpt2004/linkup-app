// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  Computed<bool>? _$isReplyingComputed;

  @override
  bool get isReplying => (_$isReplyingComputed ??=
          Computed<bool>(() => super.isReplying, name: '_ChatStore.isReplying'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: '_ChatStore.isLoading', context: context);

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

  late final _$replyingValueAtom =
      Atom(name: '_ChatStore.replyingValue', context: context);

  @override
  String? get replyingValue {
    _$replyingValueAtom.reportRead();
    return super.replyingValue;
  }

  @override
  set replyingValue(String? value) {
    _$replyingValueAtom.reportWrite(value, super.replyingValue, () {
      super.replyingValue = value;
    });
  }

  late final _$replyToMessageIdAtom =
      Atom(name: '_ChatStore.replyToMessageId', context: context);

  @override
  String? get replyToMessageId {
    _$replyToMessageIdAtom.reportRead();
    return super.replyToMessageId;
  }

  @override
  set replyToMessageId(String? value) {
    _$replyToMessageIdAtom.reportWrite(value, super.replyToMessageId, () {
      super.replyToMessageId = value;
    });
  }

  late final _$replyToUserIdAtom =
      Atom(name: '_ChatStore.replyToUserId', context: context);

  @override
  String? get replyToUserId {
    _$replyToUserIdAtom.reportRead();
    return super.replyToUserId;
  }

  @override
  set replyToUserId(String? value) {
    _$replyToUserIdAtom.reportWrite(value, super.replyToUserId, () {
      super.replyToUserId = value;
    });
  }

  late final _$replyToUserNameAtom =
      Atom(name: '_ChatStore.replyToUserName', context: context);

  @override
  String? get replyToUserName {
    _$replyToUserNameAtom.reportRead();
    return super.replyToUserName;
  }

  @override
  set replyToUserName(String? value) {
    _$replyToUserNameAtom.reportWrite(value, super.replyToUserName, () {
      super.replyToUserName = value;
    });
  }

  late final _$replyToMessageTextAtom =
      Atom(name: '_ChatStore.replyToMessageText', context: context);

  @override
  String? get replyToMessageText {
    _$replyToMessageTextAtom.reportRead();
    return super.replyToMessageText;
  }

  @override
  set replyToMessageText(String? value) {
    _$replyToMessageTextAtom.reportWrite(value, super.replyToMessageText, () {
      super.replyToMessageText = value;
    });
  }

  late final _$isRefreshingAtom =
      Atom(name: '_ChatStore.isRefreshing', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_ChatStore.errorMessage', context: context);

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

  late final _$isLoadMoreAtom =
      Atom(name: '_ChatStore.isLoadMore', context: context);

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
      Atom(name: '_ChatStore.hasMorePosts', context: context);

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

  late final _$currentPageAtom =
      Atom(name: '_ChatStore.currentPage', context: context);

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

  late final _$isResponseLoadingAtom =
      Atom(name: '_ChatStore.isResponseLoading', context: context);

  @override
  bool get isResponseLoading {
    _$isResponseLoadingAtom.reportRead();
    return super.isResponseLoading;
  }

  @override
  set isResponseLoading(bool value) {
    _$isResponseLoadingAtom.reportWrite(value, super.isResponseLoading, () {
      super.isResponseLoading = value;
    });
  }

  late final _$chatImageArrayAtom =
      Atom(name: '_ChatStore.chatImageArray', context: context);

  @override
  ObservableList<String> get chatImageArray {
    _$chatImageArrayAtom.reportRead();
    return super.chatImageArray;
  }

  @override
  set chatImageArray(ObservableList<String> value) {
    _$chatImageArrayAtom.reportWrite(value, super.chatImageArray, () {
      super.chatImageArray = value;
    });
  }

  late final _$listChatBoxMessagesAtom =
      Atom(name: '_ChatStore.listChatBoxMessages', context: context);

  @override
  ObservableList<ChatModel> get listChatBoxMessages {
    _$listChatBoxMessagesAtom.reportRead();
    return super.listChatBoxMessages;
  }

  @override
  set listChatBoxMessages(ObservableList<ChatModel> value) {
    _$listChatBoxMessagesAtom.reportWrite(value, super.listChatBoxMessages, () {
      super.listChatBoxMessages = value;
    });
  }

  late final _$listChatBoxMessagesCacheAtom =
      Atom(name: '_ChatStore.listChatBoxMessagesCache', context: context);

  @override
  ObservableList<ChatModel> get listChatBoxMessagesCache {
    _$listChatBoxMessagesCacheAtom.reportRead();
    return super.listChatBoxMessagesCache;
  }

  @override
  set listChatBoxMessagesCache(ObservableList<ChatModel> value) {
    _$listChatBoxMessagesCacheAtom
        .reportWrite(value, super.listChatBoxMessagesCache, () {
      super.listChatBoxMessagesCache = value;
    });
  }

  late final _$postIdsAndContentMapAtom =
      Atom(name: '_ChatStore.postIdsAndContentMap', context: context);

  @override
  ObservableMap<String, String> get postIdsAndContentMap {
    _$postIdsAndContentMapAtom.reportRead();
    return super.postIdsAndContentMap;
  }

  @override
  set postIdsAndContentMap(ObservableMap<String, String> value) {
    _$postIdsAndContentMapAtom.reportWrite(value, super.postIdsAndContentMap,
        () {
      super.postIdsAndContentMap = value;
    });
  }

  late final _$messageReadStatusAtom =
      Atom(name: '_ChatStore.messageReadStatus', context: context);

  @override
  ObservableMap<String, bool> get messageReadStatus {
    _$messageReadStatusAtom.reportRead();
    return super.messageReadStatus;
  }

  @override
  set messageReadStatus(ObservableMap<String, bool> value) {
    _$messageReadStatusAtom.reportWrite(value, super.messageReadStatus, () {
      super.messageReadStatus = value;
    });
  }

  late final _$lastMessageTextsAtom =
      Atom(name: '_ChatStore.lastMessageTexts', context: context);

  @override
  ObservableMap<String, String> get lastMessageTexts {
    _$lastMessageTextsAtom.reportRead();
    return super.lastMessageTexts;
  }

  @override
  set lastMessageTexts(ObservableMap<String, String> value) {
    _$lastMessageTextsAtom.reportWrite(value, super.lastMessageTexts, () {
      super.lastMessageTexts = value;
    });
  }

  late final _$sendRequestSummaryTextAsyncAction =
      AsyncAction('_ChatStore.sendRequestSummaryText', context: context);

  @override
  Future<bool> sendRequestSummaryText(String postId, String content) {
    return _$sendRequestSummaryTextAsyncAction
        .run(() => super.sendRequestSummaryText(postId, content));
  }

  late final _$sendChatBoxMessageAsyncAction =
      AsyncAction('_ChatStore.sendChatBoxMessage', context: context);

  @override
  Future<bool> sendChatBoxMessage(String content) {
    return _$sendChatBoxMessageAsyncAction
        .run(() => super.sendChatBoxMessage(content));
  }

  late final _$findHistoryChatBoxMessageAsyncAction =
      AsyncAction('_ChatStore.findHistoryChatBoxMessage', context: context);

  @override
  Future<void> findHistoryChatBoxMessage({bool refresh = false}) {
    return _$findHistoryChatBoxMessageAsyncAction
        .run(() => super.findHistoryChatBoxMessage(refresh: refresh));
  }

  late final _$checkExistRoomAsyncAction =
      AsyncAction('_ChatStore.checkExistRoom', context: context);

  @override
  Future<bool> checkExistRoom({required List<String> membersIds}) {
    return _$checkExistRoomAsyncAction
        .run(() => super.checkExistRoom(membersIds: membersIds));
  }

  late final _$initializeAsyncAction =
      AsyncAction('_ChatStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$_ChatStoreActionController =
      ActionController(name: '_ChatStore', context: context);

  @override
  void setReplyingValue(String text) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setReplyingValue');
    try {
      return super.setReplyingValue(text);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReplyTarget(
      {required String messageId,
      required String userId,
      required String userName,
      required String messageText}) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setReplyTarget');
    try {
      return super.setReplyTarget(
          messageId: messageId,
          userId: userId,
          userName: userName,
          messageText: messageText);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearReplyTarget() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearReplyTarget');
    try {
      return super.clearReplyTarget();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRefreshing(bool value) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setRefreshing');
    try {
      return super.setRefreshing(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsResponseLoading(bool value) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setIsResponseLoading');
    try {
      return super.setIsResponseLoading(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.clear');
    try {
      return super.clear();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearChatImageArray() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearChatImageArray');
    try {
      return super.clearChatImageArray();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeImage(int index) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.removeImage');
    try {
      return super.removeImage(index);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addImageIntoArray(String imagePath) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.addImageIntoArray');
    try {
      return super.addImageIntoArray(imagePath);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addArrayImageIntoArray(List<String> imagePaths) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.addArrayImageIntoArray');
    try {
      return super.addArrayImageIntoArray(imagePaths);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateReadStatus(String messageId, bool isRead) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.updateReadStatus');
    try {
      return super.updateReadStatus(messageId, isRead);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateLastMessageText(String roomId, String text) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.updateLastMessageText');
    try {
      return super.updateLastMessageText(roomId, text);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearReadStatus() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearReadStatus');
    try {
      return super.clearReadStatus();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearLastMessageTexts() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearLastMessageTexts');
    try {
      return super.clearLastMessageTexts();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool shouldShowUnreadIndicator(
      {required String messageId,
      required String senderId,
      required String currentUserId,
      required List<dynamic>? readByList}) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.shouldShowUnreadIndicator');
    try {
      return super.shouldShowUnreadIndicator(
          messageId: messageId,
          senderId: senderId,
          currentUserId: currentUserId,
          readByList: readByList);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDataSummaryMap() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.clearDataSummaryMap');
    try {
      return super.clearDataSummaryMap();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
replyingValue: ${replyingValue},
replyToMessageId: ${replyToMessageId},
replyToUserId: ${replyToUserId},
replyToUserName: ${replyToUserName},
replyToMessageText: ${replyToMessageText},
isRefreshing: ${isRefreshing},
errorMessage: ${errorMessage},
isLoadMore: ${isLoadMore},
hasMorePosts: ${hasMorePosts},
currentPage: ${currentPage},
isResponseLoading: ${isResponseLoading},
chatImageArray: ${chatImageArray},
listChatBoxMessages: ${listChatBoxMessages},
listChatBoxMessagesCache: ${listChatBoxMessagesCache},
postIdsAndContentMap: ${postIdsAndContentMap},
messageReadStatus: ${messageReadStatus},
lastMessageTexts: ${lastMessageTexts},
isReplying: ${isReplying}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostStore on _CreatePostStore, Store {
  Computed<bool>? _$hasMediaComputed;

  @override
  bool get hasMedia =>
      (_$hasMediaComputed ??= Computed<bool>(() => super.hasMedia,
              name: '_CreatePostStore.hasMedia'))
          .value;
  Computed<bool>? _$canPostComputed;

  @override
  bool get canPost => (_$canPostComputed ??=
          Computed<bool>(() => super.canPost, name: '_CreatePostStore.canPost'))
      .value;
  Computed<int>? _$totalMediaCountComputed;

  @override
  int get totalMediaCount =>
      (_$totalMediaCountComputed ??= Computed<int>(() => super.totalMediaCount,
              name: '_CreatePostStore.totalMediaCount'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_CreatePostStore.hasError'))
          .value;
  Computed<String>? _$currentPrivacyComputed;

  @override
  String get currentPrivacy =>
      (_$currentPrivacyComputed ??= Computed<String>(() => super.currentPrivacy,
              name: '_CreatePostStore.currentPrivacy'))
          .value;
  Computed<List<String>>? _$currentMentionsComputed;

  @override
  List<String> get currentMentions => (_$currentMentionsComputed ??=
          Computed<List<String>>(() => super.currentMentions,
              name: '_CreatePostStore.currentMentions'))
      .value;
  Computed<String>? _$aiStatusTextComputed;

  @override
  String get aiStatusText =>
      (_$aiStatusTextComputed ??= Computed<String>(() => super.aiStatusText,
              name: '_CreatePostStore.aiStatusText'))
          .value;
  Computed<String>? _$micStatusTextComputed;

  @override
  String get micStatusText =>
      (_$micStatusTextComputed ??= Computed<String>(() => super.micStatusText,
              name: '_CreatePostStore.micStatusText'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: '_CreatePostStore.isLoading', context: context);

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

  late final _$isUploadingAtom =
      Atom(name: '_CreatePostStore.isUploading', context: context);

  @override
  bool get isUploading {
    _$isUploadingAtom.reportRead();
    return super.isUploading;
  }

  @override
  set isUploading(bool value) {
    _$isUploadingAtom.reportWrite(value, super.isUploading, () {
      super.isUploading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_CreatePostStore.errorMessage', context: context);

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

  late final _$captionAtom =
      Atom(name: '_CreatePostStore.caption', context: context);

  @override
  String get caption {
    _$captionAtom.reportRead();
    return super.caption;
  }

  @override
  set caption(String value) {
    _$captionAtom.reportWrite(value, super.caption, () {
      super.caption = value;
    });
  }

  late final _$postsAtom =
      Atom(name: '_CreatePostStore.posts', context: context);

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

  late final _$selectedImagePathsAtom =
      Atom(name: '_CreatePostStore.selectedImagePaths', context: context);

  @override
  ObservableList<String> get selectedImagePaths {
    _$selectedImagePathsAtom.reportRead();
    return super.selectedImagePaths;
  }

  @override
  set selectedImagePaths(ObservableList<String> value) {
    _$selectedImagePathsAtom.reportWrite(value, super.selectedImagePaths, () {
      super.selectedImagePaths = value;
    });
  }

  late final _$selectedVideoPathsAtom =
      Atom(name: '_CreatePostStore.selectedVideoPaths', context: context);

  @override
  ObservableList<String> get selectedVideoPaths {
    _$selectedVideoPathsAtom.reportRead();
    return super.selectedVideoPaths;
  }

  @override
  set selectedVideoPaths(ObservableList<String> value) {
    _$selectedVideoPathsAtom.reportWrite(value, super.selectedVideoPaths, () {
      super.selectedVideoPaths = value;
    });
  }

  late final _$uploadedImageUrlsAtom =
      Atom(name: '_CreatePostStore.uploadedImageUrls', context: context);

  @override
  ObservableList<String> get uploadedImageUrls {
    _$uploadedImageUrlsAtom.reportRead();
    return super.uploadedImageUrls;
  }

  @override
  set uploadedImageUrls(ObservableList<String> value) {
    _$uploadedImageUrlsAtom.reportWrite(value, super.uploadedImageUrls, () {
      super.uploadedImageUrls = value;
    });
  }

  late final _$uploadedVideoUrlsAtom =
      Atom(name: '_CreatePostStore.uploadedVideoUrls', context: context);

  @override
  ObservableList<String> get uploadedVideoUrls {
    _$uploadedVideoUrlsAtom.reportRead();
    return super.uploadedVideoUrls;
  }

  @override
  set uploadedVideoUrls(ObservableList<String> value) {
    _$uploadedVideoUrlsAtom.reportWrite(value, super.uploadedVideoUrls, () {
      super.uploadedVideoUrls = value;
    });
  }

  late final _$isMicEnabledAtom =
      Atom(name: '_CreatePostStore.isMicEnabled', context: context);

  @override
  bool get isMicEnabled {
    _$isMicEnabledAtom.reportRead();
    return super.isMicEnabled;
  }

  @override
  set isMicEnabled(bool value) {
    _$isMicEnabledAtom.reportWrite(value, super.isMicEnabled, () {
      super.isMicEnabled = value;
    });
  }

  late final _$isAIGenCaptionEnabledAtom =
      Atom(name: '_CreatePostStore.isAIGenCaptionEnabled', context: context);

  @override
  bool get isAIGenCaptionEnabled {
    _$isAIGenCaptionEnabledAtom.reportRead();
    return super.isAIGenCaptionEnabled;
  }

  @override
  set isAIGenCaptionEnabled(bool value) {
    _$isAIGenCaptionEnabledAtom.reportWrite(value, super.isAIGenCaptionEnabled,
        () {
      super.isAIGenCaptionEnabled = value;
    });
  }

  late final _$isAIGenImageEnabledAtom =
      Atom(name: '_CreatePostStore.isAIGenImageEnabled', context: context);

  @override
  bool get isAIGenImageEnabled {
    _$isAIGenImageEnabledAtom.reportRead();
    return super.isAIGenImageEnabled;
  }

  @override
  set isAIGenImageEnabled(bool value) {
    _$isAIGenImageEnabledAtom.reportWrite(value, super.isAIGenImageEnabled, () {
      super.isAIGenImageEnabled = value;
    });
  }

  late final _$aiCaptionAutoCorrectAtom =
      Atom(name: '_CreatePostStore.aiCaptionAutoCorrect', context: context);

  @override
  bool get aiCaptionAutoCorrect {
    _$aiCaptionAutoCorrectAtom.reportRead();
    return super.aiCaptionAutoCorrect;
  }

  @override
  set aiCaptionAutoCorrect(bool value) {
    _$aiCaptionAutoCorrectAtom.reportWrite(value, super.aiCaptionAutoCorrect,
        () {
      super.aiCaptionAutoCorrect = value;
    });
  }

  late final _$aiCaptionAddHashtagsAtom =
      Atom(name: '_CreatePostStore.aiCaptionAddHashtags', context: context);

  @override
  bool get aiCaptionAddHashtags {
    _$aiCaptionAddHashtagsAtom.reportRead();
    return super.aiCaptionAddHashtags;
  }

  @override
  set aiCaptionAddHashtags(bool value) {
    _$aiCaptionAddHashtagsAtom.reportWrite(value, super.aiCaptionAddHashtags,
        () {
      super.aiCaptionAddHashtags = value;
    });
  }

  late final _$aiCaptionTranslateAtom =
      Atom(name: '_CreatePostStore.aiCaptionTranslate', context: context);

  @override
  bool get aiCaptionTranslate {
    _$aiCaptionTranslateAtom.reportRead();
    return super.aiCaptionTranslate;
  }

  @override
  set aiCaptionTranslate(bool value) {
    _$aiCaptionTranslateAtom.reportWrite(value, super.aiCaptionTranslate, () {
      super.aiCaptionTranslate = value;
    });
  }

  late final _$aiImageEnhanceQualityAtom =
      Atom(name: '_CreatePostStore.aiImageEnhanceQuality', context: context);

  @override
  bool get aiImageEnhanceQuality {
    _$aiImageEnhanceQualityAtom.reportRead();
    return super.aiImageEnhanceQuality;
  }

  @override
  set aiImageEnhanceQuality(bool value) {
    _$aiImageEnhanceQualityAtom.reportWrite(value, super.aiImageEnhanceQuality,
        () {
      super.aiImageEnhanceQuality = value;
    });
  }

  late final _$aiImageAddFiltersAtom =
      Atom(name: '_CreatePostStore.aiImageAddFilters', context: context);

  @override
  bool get aiImageAddFilters {
    _$aiImageAddFiltersAtom.reportRead();
    return super.aiImageAddFilters;
  }

  @override
  set aiImageAddFilters(bool value) {
    _$aiImageAddFiltersAtom.reportWrite(value, super.aiImageAddFilters, () {
      super.aiImageAddFilters = value;
    });
  }

  late final _$aiImageAutoResizeAtom =
      Atom(name: '_CreatePostStore.aiImageAutoResize', context: context);

  @override
  bool get aiImageAutoResize {
    _$aiImageAutoResizeAtom.reportRead();
    return super.aiImageAutoResize;
  }

  @override
  set aiImageAutoResize(bool value) {
    _$aiImageAutoResizeAtom.reportWrite(value, super.aiImageAutoResize, () {
      super.aiImageAutoResize = value;
    });
  }

  late final _$linksAtom =
      Atom(name: '_CreatePostStore.links', context: context);

  @override
  ObservableList<LinkModel> get links {
    _$linksAtom.reportRead();
    return super.links;
  }

  @override
  set links(ObservableList<LinkModel> value) {
    _$linksAtom.reportWrite(value, super.links, () {
      super.links = value;
    });
  }

  late final _$hashtagsAtom =
      Atom(name: '_CreatePostStore.hashtags', context: context);

  @override
  ObservableList<String> get hashtags {
    _$hashtagsAtom.reportRead();
    return super.hashtags;
  }

  @override
  set hashtags(ObservableList<String> value) {
    _$hashtagsAtom.reportWrite(value, super.hashtags, () {
      super.hashtags = value;
    });
  }

  late final _$mentionsAtom =
      Atom(name: '_CreatePostStore.mentions', context: context);

  @override
  ObservableList<String> get mentions {
    _$mentionsAtom.reportRead();
    return super.mentions;
  }

  @override
  set mentions(ObservableList<String> value) {
    _$mentionsAtom.reportWrite(value, super.mentions, () {
      super.mentions = value;
    });
  }

  late final _$postNeedWifiAtom =
      Atom(name: '_CreatePostStore.postNeedWifi', context: context);

  @override
  ObservableList<PostModel> get postNeedWifi {
    _$postNeedWifiAtom.reportRead();
    return super.postNeedWifi;
  }

  @override
  set postNeedWifi(ObservableList<PostModel> value) {
    _$postNeedWifiAtom.reportWrite(value, super.postNeedWifi, () {
      super.postNeedWifi = value;
    });
  }

  late final _$draftAtom =
      Atom(name: '_CreatePostStore.draft', context: context);

  @override
  Map<String, dynamic>? get draft {
    _$draftAtom.reportRead();
    return super.draft;
  }

  @override
  set draft(Map<String, dynamic>? value) {
    _$draftAtom.reportWrite(value, super.draft, () {
      super.draft = value;
    });
  }

  late final _$selectedUsersAtom =
      Atom(name: '_CreatePostStore.selectedUsers', context: context);

  @override
  ObservableList<dynamic> get selectedUsers {
    _$selectedUsersAtom.reportRead();
    return super.selectedUsers;
  }

  @override
  set selectedUsers(ObservableList<dynamic> value) {
    _$selectedUsersAtom.reportWrite(value, super.selectedUsers, () {
      super.selectedUsers = value;
    });
  }

  late final _$saveDraftAsyncAction =
      AsyncAction('_CreatePostStore.saveDraft', context: context);

  @override
  Future<void> saveDraft() {
    return _$saveDraftAsyncAction.run(() => super.saveDraft());
  }

  late final _$checkPostNeedWifiAsyncAction =
      AsyncAction('_CreatePostStore.checkPostNeedWifi', context: context);

  @override
  Future<bool> checkPostNeedWifi(String postId) {
    return _$checkPostNeedWifiAsyncAction
        .run(() => super.checkPostNeedWifi(postId));
  }

  late final _$postQueuedPostsWhenOnlineAsyncAction = AsyncAction(
      '_CreatePostStore.postQueuedPostsWhenOnline',
      context: context);

  @override
  Future<void> postQueuedPostsWhenOnline() {
    return _$postQueuedPostsWhenOnlineAsyncAction
        .run(() => super.postQueuedPostsWhenOnline());
  }

  late final _$createPostAsyncAction =
      AsyncAction('_CreatePostStore.createPost', context: context);

  @override
  Future<bool> createPost(bool isWifi, Map<String, dynamic>? currentUser,
      [Map<String, dynamic>? postData]) {
    return _$createPostAsyncAction
        .run(() => super.createPost(isWifi, currentUser, postData));
  }

  late final _$syncPostsAfterReconnectionAsyncAction = AsyncAction(
      '_CreatePostStore.syncPostsAfterReconnection',
      context: context);

  @override
  Future<void> syncPostsAfterReconnection() {
    return _$syncPostsAfterReconnectionAsyncAction
        .run(() => super.syncPostsAfterReconnection());
  }

  late final _$_CreatePostStoreActionController =
      ActionController(name: '_CreatePostStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUploading(bool value) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setUploading');
    try {
      return super.setUploading(value);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCaption(String value) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setCaption');
    try {
      return super.setCaption(value);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMicEnabled(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setMicEnabled');
    try {
      return super.setMicEnabled(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAIGenCaptionEnabled(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAIGenCaptionEnabled');
    try {
      return super.setAIGenCaptionEnabled(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAIGenImageEnabled(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAIGenImageEnabled');
    try {
      return super.setAIGenImageEnabled(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAICaptionAutoCorrect(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAICaptionAutoCorrect');
    try {
      return super.setAICaptionAutoCorrect(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAICaptionAddHashtags(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAICaptionAddHashtags');
    try {
      return super.setAICaptionAddHashtags(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAICaptionTranslate(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAICaptionTranslate');
    try {
      return super.setAICaptionTranslate(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAIImageEnhanceQuality(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAIImageEnhanceQuality');
    try {
      return super.setAIImageEnhanceQuality(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAIImageAddFilters(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAIImageAddFilters');
    try {
      return super.setAIImageAddFilters(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAIImageAutoResize(bool enabled) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setAIImageAutoResize');
    try {
      return super.setAIImageAutoResize(enabled);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addImagePath(String path) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.addImagePath');
    try {
      return super.addImagePath(path);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeImagePath(int index) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeImagePath');
    try {
      return super.removeImagePath(index);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addVideoPath(String path) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.addVideoPath');
    try {
      return super.addVideoPath(path);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeVideoPath(int index) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeVideoPath');
    try {
      return super.removeVideoPath(index);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedMedia() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearSelectedMedia');
    try {
      return super.clearSelectedMedia();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedImages() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearSelectedImages');
    try {
      return super.clearSelectedImages();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedVideos() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearSelectedVideos');
    try {
      return super.clearSelectedVideos();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedUsers() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearSelectedUsers');
    try {
      return super.clearSelectedUsers();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addHashtag(String tag) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.addHashtag');
    try {
      return super.addHashtag(tag);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeHashtag(String tag) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeHashtag');
    try {
      return super.removeHashtag(tag);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addMention(String mention) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.addMention');
    try {
      return super.addMention(mention);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMention(String mention) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeMention');
    try {
      return super.removeMention(mention);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addLink(LinkModel link) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.addLink');
    try {
      return super.addLink(link);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeLink(String url) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeLink');
    try {
      return super.removeLink(url);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLinks(List<LinkModel> linkList) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setLinks');
    try {
      return super.setLinks(linkList);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHashtags(List<String> hashtags) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.setHashtags');
    try {
      return super.setHashtags(hashtags);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDraft() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.clearDraft');
    try {
      return super.clearDraft();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeQueuedPost(String postId) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeQueuedPost');
    try {
      return super.removeQueuedPost(postId);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isUploading: ${isUploading},
errorMessage: ${errorMessage},
caption: ${caption},
posts: ${posts},
selectedImagePaths: ${selectedImagePaths},
selectedVideoPaths: ${selectedVideoPaths},
uploadedImageUrls: ${uploadedImageUrls},
uploadedVideoUrls: ${uploadedVideoUrls},
isMicEnabled: ${isMicEnabled},
isAIGenCaptionEnabled: ${isAIGenCaptionEnabled},
isAIGenImageEnabled: ${isAIGenImageEnabled},
aiCaptionAutoCorrect: ${aiCaptionAutoCorrect},
aiCaptionAddHashtags: ${aiCaptionAddHashtags},
aiCaptionTranslate: ${aiCaptionTranslate},
aiImageEnhanceQuality: ${aiImageEnhanceQuality},
aiImageAddFilters: ${aiImageAddFilters},
aiImageAutoResize: ${aiImageAutoResize},
links: ${links},
hashtags: ${hashtags},
mentions: ${mentions},
postNeedWifi: ${postNeedWifi},
draft: ${draft},
selectedUsers: ${selectedUsers},
hasMedia: ${hasMedia},
canPost: ${canPost},
totalMediaCount: ${totalMediaCount},
hasError: ${hasError},
currentPrivacy: ${currentPrivacy},
currentMentions: ${currentMentions},
aiStatusText: ${aiStatusText},
micStatusText: ${micStatusText}
    ''';
  }
}

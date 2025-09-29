// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardController on _DashboardController, Store {
  Computed<String>? _$currentPageNameComputed;

  @override
  String get currentPageName => (_$currentPageNameComputed ??= Computed<String>(
          () => super.currentPageName,
          name: '_DashboardController.currentPageName'))
      .value;
  Computed<bool>? _$isHomePageComputed;

  @override
  bool get isHomePage =>
      (_$isHomePageComputed ??= Computed<bool>(() => super.isHomePage,
              name: '_DashboardController.isHomePage'))
          .value;
  Computed<bool>? _$isFriendsPageComputed;

  @override
  bool get isFriendsPage =>
      (_$isFriendsPageComputed ??= Computed<bool>(() => super.isFriendsPage,
              name: '_DashboardController.isFriendsPage'))
          .value;
  Computed<bool>? _$isFriendActionsPageComputed;

  @override
  bool get isFriendActionsPage => (_$isFriendActionsPageComputed ??=
          Computed<bool>(() => super.isFriendActionsPage,
              name: '_DashboardController.isFriendActionsPage'))
      .value;
  Computed<bool>? _$isSuggestionsPageComputed;

  @override
  bool get isSuggestionsPage => (_$isSuggestionsPageComputed ??= Computed<bool>(
          () => super.isSuggestionsPage,
          name: '_DashboardController.isSuggestionsPage'))
      .value;
  Computed<int>? _$unreadNotificationsCountComputed;

  @override
  int get unreadNotificationsCount => (_$unreadNotificationsCountComputed ??=
          Computed<int>(() => super.unreadNotificationsCount,
              name: '_DashboardController.unreadNotificationsCount'))
      .value;
  Computed<List<Map<String, dynamic>>>? _$unreadNotificationsComputed;

  @override
  List<Map<String, dynamic>> get unreadNotifications =>
      (_$unreadNotificationsComputed ??= Computed<List<Map<String, dynamic>>>(
              () => super.unreadNotifications,
              name: '_DashboardController.unreadNotifications'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_DashboardController.hasError'))
          .value;

  late final _$currentPageIndexAtom =
      Atom(name: '_DashboardController.currentPageIndex', context: context);

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  late final _$isDrawerOpenAtom =
      Atom(name: '_DashboardController.isDrawerOpen', context: context);

  @override
  bool get isDrawerOpen {
    _$isDrawerOpenAtom.reportRead();
    return super.isDrawerOpen;
  }

  @override
  set isDrawerOpen(bool value) {
    _$isDrawerOpenAtom.reportWrite(value, super.isDrawerOpen, () {
      super.isDrawerOpen = value;
    });
  }

  late final _$notificationsAtom =
      Atom(name: '_DashboardController.notifications', context: context);

  @override
  ObservableList<Map<String, dynamic>> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(ObservableList<Map<String, dynamic>> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$hasUnreadNotificationsAtom = Atom(
      name: '_DashboardController.hasUnreadNotifications', context: context);

  @override
  bool get hasUnreadNotifications {
    _$hasUnreadNotificationsAtom.reportRead();
    return super.hasUnreadNotifications;
  }

  @override
  set hasUnreadNotifications(bool value) {
    _$hasUnreadNotificationsAtom
        .reportWrite(value, super.hasUnreadNotifications, () {
      super.hasUnreadNotifications = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_DashboardController.errorMessage', context: context);

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

  late final _$loadNotificationsAsyncAction =
      AsyncAction('_DashboardController.loadNotifications', context: context);

  @override
  Future<void> loadNotifications() {
    return _$loadNotificationsAsyncAction.run(() => super.loadNotifications());
  }

  late final _$markNotificationAsReadAsyncAction = AsyncAction(
      '_DashboardController.markNotificationAsRead',
      context: context);

  @override
  Future<bool> markNotificationAsRead(int notificationId) {
    return _$markNotificationAsReadAsyncAction
        .run(() => super.markNotificationAsRead(notificationId));
  }

  late final _$markAllNotificationsAsReadAsyncAction = AsyncAction(
      '_DashboardController.markAllNotificationsAsRead',
      context: context);

  @override
  Future<bool> markAllNotificationsAsRead() {
    return _$markAllNotificationsAsReadAsyncAction
        .run(() => super.markAllNotificationsAsRead());
  }

  late final _$deleteNotificationAsyncAction =
      AsyncAction('_DashboardController.deleteNotification', context: context);

  @override
  Future<bool> deleteNotification(int notificationId) {
    return _$deleteNotificationAsyncAction
        .run(() => super.deleteNotification(notificationId));
  }

  late final _$initializeAsyncAction =
      AsyncAction('_DashboardController.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$_DashboardControllerActionController =
      ActionController(name: '_DashboardController', context: context);

  @override
  void setCurrentPage(int index) {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.setCurrentPage');
    try {
      return super.setCurrentPage(index);
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDrawerState(bool isOpen) {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.setDrawerState');
    try {
      return super.setDrawerState(isOpen);
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.setError');
    try {
      return super.setError(error);
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.clearError');
    try {
      return super.clearError();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToHome() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.navigateToHome');
    try {
      return super.navigateToHome();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToFriends() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.navigateToFriends');
    try {
      return super.navigateToFriends();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToFriendActions() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.navigateToFriendActions');
    try {
      return super.navigateToFriendActions();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToSuggestions() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.navigateToSuggestions');
    try {
      return super.navigateToSuggestions();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openDrawer() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.openDrawer');
    try {
      return super.openDrawer();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeDrawer() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.closeDrawer');
    try {
      return super.closeDrawer();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDrawer() {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.toggleDrawer');
    try {
      return super.toggleDrawer();
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToPage(int index) {
    final _$actionInfo = _$_DashboardControllerActionController.startAction(
        name: '_DashboardController.navigateToPage');
    try {
      return super.navigateToPage(index);
    } finally {
      _$_DashboardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
isDrawerOpen: ${isDrawerOpen},
notifications: ${notifications},
hasUnreadNotifications: ${hasUnreadNotifications},
errorMessage: ${errorMessage},
currentPageName: ${currentPageName},
isHomePage: ${isHomePage},
isFriendsPage: ${isFriendsPage},
isFriendActionsPage: ${isFriendActionsPage},
isSuggestionsPage: ${isSuggestionsPage},
unreadNotificationsCount: ${unreadNotificationsCount},
unreadNotifications: ${unreadNotifications},
hasError: ${hasError}
    ''';
  }
}

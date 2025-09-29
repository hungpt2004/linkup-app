// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationStore on _NotificationStore, Store {
  Computed<int>? _$unreadNotificationCountComputed;

  @override
  int get unreadNotificationCount => (_$unreadNotificationCountComputed ??=
          Computed<int>(() => super.unreadNotificationCount,
              name: '_NotificationStore.unreadNotificationCount'))
      .value;

  late final _$ownNotificationsAtom =
      Atom(name: '_NotificationStore.ownNotifications', context: context);

  @override
  ObservableList<NotificationModel> get ownNotifications {
    _$ownNotificationsAtom.reportRead();
    return super.ownNotifications;
  }

  @override
  set ownNotifications(ObservableList<NotificationModel> value) {
    _$ownNotificationsAtom.reportWrite(value, super.ownNotifications, () {
      super.ownNotifications = value;
    });
  }

  late final _$logActivitiesAtom =
      Atom(name: '_NotificationStore.logActivities', context: context);

  @override
  ObservableList<NotificationModel> get logActivities {
    _$logActivitiesAtom.reportRead();
    return super.logActivities;
  }

  @override
  set logActivities(ObservableList<NotificationModel> value) {
    _$logActivitiesAtom.reportWrite(value, super.logActivities, () {
      super.logActivities = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_NotificationStore.isLoading', context: context);

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

  late final _$createNotificationAsyncAction =
      AsyncAction('_NotificationStore.createNotification', context: context);

  @override
  Future<String> createNotification(
      {String? referenceId,
      required UserEntity authorInformation,
      required List<UserModel> friends,
      required String actionAuthorId,
      required String contentNotification,
      required String typeNotification,
      required String deepLink}) {
    return _$createNotificationAsyncAction.run(() => super.createNotification(
        referenceId: referenceId,
        authorInformation: authorInformation,
        friends: friends,
        actionAuthorId: actionAuthorId,
        contentNotification: contentNotification,
        typeNotification: typeNotification,
        deepLink: deepLink));
  }

  late final _$_NotificationStoreActionController =
      ActionController(name: '_NotificationStore', context: context);

  @override
  void listenOwnNotifications({required String userId, String? type}) {
    final _$actionInfo = _$_NotificationStoreActionController.startAction(
        name: '_NotificationStore.listenOwnNotifications');
    try {
      return super.listenOwnNotifications(userId: userId, type: type);
    } finally {
      _$_NotificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void listenLogActivities({required String userId, String? type}) {
    final _$actionInfo = _$_NotificationStoreActionController.startAction(
        name: '_NotificationStore.listenLogActivities');
    try {
      return super.listenLogActivities(userId: userId, type: type);
    } finally {
      _$_NotificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ownNotifications: ${ownNotifications},
logActivities: ${logActivities},
isLoading: ${isLoading},
unreadNotificationCount: ${unreadNotificationCount}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_people_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TagUserStore on _TagUserStore, Store {
  late final _$usersAtom = Atom(name: '_TagUserStore.users', context: context);

  @override
  ObservableList<Map<String, dynamic>> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<Map<String, dynamic>> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$searchUsersAtom =
      Atom(name: '_TagUserStore.searchUsers', context: context);

  @override
  ObservableList<UserModel> get searchUsers {
    _$searchUsersAtom.reportRead();
    return super.searchUsers;
  }

  @override
  set searchUsers(ObservableList<UserModel> value) {
    _$searchUsersAtom.reportWrite(value, super.searchUsers, () {
      super.searchUsers = value;
    });
  }

  late final _$selectedUserIdsAtom =
      Atom(name: '_TagUserStore.selectedUserIds', context: context);

  @override
  ObservableSet<String> get selectedUserIds {
    _$selectedUserIdsAtom.reportRead();
    return super.selectedUserIds;
  }

  @override
  set selectedUserIds(ObservableSet<String> value) {
    _$selectedUserIdsAtom.reportWrite(value, super.selectedUserIds, () {
      super.selectedUserIds = value;
    });
  }

  late final _$selectedUserInforAtom =
      Atom(name: '_TagUserStore.selectedUserInfor', context: context);

  @override
  ObservableList<UserModel> get selectedUserInfor {
    _$selectedUserInforAtom.reportRead();
    return super.selectedUserInfor;
  }

  @override
  set selectedUserInfor(ObservableList<UserModel> value) {
    _$selectedUserInforAtom.reportWrite(value, super.selectedUserInfor, () {
      super.selectedUserInfor = value;
    });
  }

  late final _$_TagUserStoreActionController =
      ActionController(name: '_TagUserStore', context: context);

  @override
  void clearSelectedUserInfor() {
    final _$actionInfo = _$_TagUserStoreActionController.startAction(
        name: '_TagUserStore.clearSelectedUserInfor');
    try {
      return super.clearSelectedUserInfor();
    } finally {
      _$_TagUserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleChooseUser(String userId, bool checkChoose, BuildContext context) {
    final _$actionInfo = _$_TagUserStoreActionController.startAction(
        name: '_TagUserStore.toggleChooseUser');
    try {
      return super.toggleChooseUser(userId, checkChoose, context);
    } finally {
      _$_TagUserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchUser(String searchText, BuildContext context) {
    final _$actionInfo = _$_TagUserStoreActionController.startAction(
        name: '_TagUserStore.searchUser');
    try {
      return super.searchUser(searchText, context);
    } finally {
      _$_TagUserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
searchUsers: ${searchUsers},
selectedUserIds: ${selectedUserIds},
selectedUserInfor: ${selectedUserInfor}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NavigationStore on _NavigationStore, Store {
  Computed<String>? _$currentPageTitleComputed;

  @override
  String get currentPageTitle => (_$currentPageTitleComputed ??=
          Computed<String>(() => super.currentPageTitle,
              name: '_NavigationStore.currentPageTitle'))
      .value;

  late final _$currentPageIndexAtom =
      Atom(name: '_NavigationStore.currentPageIndex', context: context);

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
      Atom(name: '_NavigationStore.isDrawerOpen', context: context);

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

  late final _$_NavigationStoreActionController =
      ActionController(name: '_NavigationStore', context: context);

  @override
  void setCurrentPage(int index) {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.setCurrentPage');
    try {
      return super.setCurrentPage(index);
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openDrawer() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.openDrawer');
    try {
      return super.openDrawer();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeDrawer() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.closeDrawer');
    try {
      return super.closeDrawer();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDrawer() {
    final _$actionInfo = _$_NavigationStoreActionController.startAction(
        name: '_NavigationStore.toggleDrawer');
    try {
      return super.toggleDrawer();
    } finally {
      _$_NavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
isDrawerOpen: ${isDrawerOpen},
currentPageTitle: ${currentPageTitle}
    ''';
  }
}

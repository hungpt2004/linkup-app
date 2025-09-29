// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeepLinkStore on _DeepLinkStoreBase, Store {
  late final _$currentDeepLinkAtom =
      Atom(name: '_DeepLinkStoreBase.currentDeepLink', context: context);

  @override
  String? get currentDeepLink {
    _$currentDeepLinkAtom.reportRead();
    return super.currentDeepLink;
  }

  @override
  set currentDeepLink(String? value) {
    _$currentDeepLinkAtom.reportWrite(value, super.currentDeepLink, () {
      super.currentDeepLink = value;
    });
  }

  late final _$isProcessingLinkAtom =
      Atom(name: '_DeepLinkStoreBase.isProcessingLink', context: context);

  @override
  bool get isProcessingLink {
    _$isProcessingLinkAtom.reportRead();
    return super.isProcessingLink;
  }

  @override
  set isProcessingLink(bool value) {
    _$isProcessingLinkAtom.reportWrite(value, super.isProcessingLink, () {
      super.isProcessingLink = value;
    });
  }

  late final _$lastErrorAtom =
      Atom(name: '_DeepLinkStoreBase.lastError', context: context);

  @override
  String? get lastError {
    _$lastErrorAtom.reportRead();
    return super.lastError;
  }

  @override
  set lastError(String? value) {
    _$lastErrorAtom.reportWrite(value, super.lastError, () {
      super.lastError = value;
    });
  }

  late final _$handleDeepLinkAsyncAction =
      AsyncAction('_DeepLinkStoreBase.handleDeepLink', context: context);

  @override
  Future<void> handleDeepLink(Uri uri) {
    return _$handleDeepLinkAsyncAction.run(() => super.handleDeepLink(uri));
  }

  late final _$_DeepLinkStoreBaseActionController =
      ActionController(name: '_DeepLinkStoreBase', context: context);

  @override
  void setCurrentDeepLink(String? link) {
    final _$actionInfo = _$_DeepLinkStoreBaseActionController.startAction(
        name: '_DeepLinkStoreBase.setCurrentDeepLink');
    try {
      return super.setCurrentDeepLink(link);
    } finally {
      _$_DeepLinkStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsProcessingLink(bool processing) {
    final _$actionInfo = _$_DeepLinkStoreBaseActionController.startAction(
        name: '_DeepLinkStoreBase.setIsProcessingLink');
    try {
      return super.setIsProcessingLink(processing);
    } finally {
      _$_DeepLinkStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastError(String? error) {
    final _$actionInfo = _$_DeepLinkStoreBaseActionController.startAction(
        name: '_DeepLinkStoreBase.setLastError');
    try {
      return super.setLastError(error);
    } finally {
      _$_DeepLinkStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentDeepLink: ${currentDeepLink},
isProcessingLink: ${isProcessingLink},
lastError: ${lastError}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  late final _$suggestionsAtom =
      Atom(name: '_UserStore.suggestions', context: context);

  @override
  ObservableList<UserModel> get suggestions {
    _$suggestionsAtom.reportRead();
    return super.suggestions;
  }

  @override
  set suggestions(ObservableList<UserModel> value) {
    _$suggestionsAtom.reportWrite(value, super.suggestions, () {
      super.suggestions = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_UserStore.isLoading', context: context);

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

  late final _$successMessageAtom =
      Atom(name: '_UserStore.successMessage', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_UserStore.errorMessage', context: context);

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

  late final _$findAllSuggestionAsyncAction =
      AsyncAction('_UserStore.findAllSuggestion', context: context);

  @override
  Future<bool> findAllSuggestion() {
    return _$findAllSuggestionAsyncAction.run(() => super.findAllSuggestion());
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  void setSuccessMessage(String? value) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setSuccessMessage');
    try {
      return super.setSuccessMessage(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? value) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setErrorMessage');
    try {
      return super.setErrorMessage(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
suggestions: ${suggestions},
isLoading: ${isLoading},
successMessage: ${successMessage},
errorMessage: ${errorMessage}
    ''';
  }
}

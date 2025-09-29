// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_AuthStore.isFormValid'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??=
          Computed<bool>(() => super.hasError, name: '_AuthStore.hasError'))
      .value;

  late final _$listProvincesAtom =
      Atom(name: '_AuthStore.listProvinces', context: context);

  @override
  List<ProvinceModel>? get listProvinces {
    _$listProvincesAtom.reportRead();
    return super.listProvinces;
  }

  @override
  set listProvinces(List<ProvinceModel>? value) {
    _$listProvincesAtom.reportWrite(value, super.listProvinces, () {
      super.listProvinces = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AuthStore.isLoading', context: context);

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

  late final _$isLoadingUploadAtom =
      Atom(name: '_AuthStore.isLoadingUpload', context: context);

  @override
  bool get isLoadingUpload {
    _$isLoadingUploadAtom.reportRead();
    return super.isLoadingUpload;
  }

  @override
  set isLoadingUpload(bool value) {
    _$isLoadingUploadAtom.reportWrite(value, super.isLoadingUpload, () {
      super.isLoadingUpload = value;
    });
  }

  late final _$isLoadingProvinceAtom =
      Atom(name: '_AuthStore.isLoadingProvince', context: context);

  @override
  bool get isLoadingProvince {
    _$isLoadingProvinceAtom.reportRead();
    return super.isLoadingProvince;
  }

  @override
  set isLoadingProvince(bool value) {
    _$isLoadingProvinceAtom.reportWrite(value, super.isLoadingProvince, () {
      super.isLoadingProvince = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_AuthStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AuthStore.token', context: context);

  @override
  String? get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String? value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_AuthStore.errorMessage', context: context);

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

  late final _$nameAtom = Atom(name: '_AuthStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$emailAtom = Atom(name: '_AuthStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AuthStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$isRememberMeAtom =
      Atom(name: '_AuthStore.isRememberMe', context: context);

  @override
  bool get isRememberMe {
    _$isRememberMeAtom.reportRead();
    return super.isRememberMe;
  }

  @override
  set isRememberMe(bool value) {
    _$isRememberMeAtom.reportWrite(value, super.isRememberMe, () {
      super.isRememberMe = value;
    });
  }

  late final _$successMessageAtom =
      Atom(name: '_AuthStore.successMessage', context: context);

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

  late final _$userInfoAtom =
      Atom(name: '_AuthStore.userInfo', context: context);

  @override
  Map<String, dynamic>? get userInfo {
    _$userInfoAtom.reportRead();
    return super.userInfo;
  }

  @override
  set userInfo(Map<String, dynamic>? value) {
    _$userInfoAtom.reportWrite(value, super.userInfo, () {
      super.userInfo = value;
    });
  }

  late final _$loadVietNamProvincesAsyncAction =
      AsyncAction('_AuthStore.loadVietNamProvinces', context: context);

  @override
  Future<void> loadVietNamProvinces() {
    return _$loadVietNamProvincesAsyncAction
        .run(() => super.loadVietNamProvinces());
  }

  late final _$checkLoginStatusAsyncAction =
      AsyncAction('_AuthStore.checkLoginStatus', context: context);

  @override
  Future<void> checkLoginStatus() {
    return _$checkLoginStatusAsyncAction.run(() => super.checkLoginStatus());
  }

  late final _$getProfileUserAsyncAction =
      AsyncAction('_AuthStore.getProfileUser', context: context);

  @override
  Future<bool> getProfileUser() {
    return _$getProfileUserAsyncAction.run(() => super.getProfileUser());
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthStore.login', context: context);

  @override
  Future<bool> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$registerAsyncAction =
      AsyncAction('_AuthStore.register', context: context);

  @override
  Future<bool> register(
      String name, String email, String password, String confirmPassword) {
    return _$registerAsyncAction
        .run(() => super.register(name, email, password, confirmPassword));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout(BuildContext context) {
    return _$logoutAsyncAction.run(() => super.logout(context));
  }

  late final _$forgotPasswordAsyncAction =
      AsyncAction('_AuthStore.forgotPassword', context: context);

  @override
  Future<bool> forgotPassword(String email) {
    return _$forgotPasswordAsyncAction.run(() => super.forgotPassword(email));
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('_AuthStore.resetPassword', context: context);

  @override
  Future<bool> resetPassword(String token, String newPassword) {
    return _$resetPasswordAsyncAction
        .run(() => super.resetPassword(token, newPassword));
  }

  late final _$uploadAvatarAsyncAction =
      AsyncAction('_AuthStore.uploadAvatar', context: context);

  @override
  Future<bool> uploadAvatar(String imagePath) {
    return _$uploadAvatarAsyncAction.run(() => super.uploadAvatar(imagePath));
  }

  late final _$uploadBackgroundAsyncAction =
      AsyncAction('_AuthStore.uploadBackground', context: context);

  @override
  Future<bool> uploadBackground(String imagePath) {
    return _$uploadBackgroundAsyncAction
        .run(() => super.uploadBackground(imagePath));
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  void setName(String value) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserInfo(Map<String, dynamic> newUserInfo) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setUserInfo');
    try {
      return super.setUserInfo(newUserInfo);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListProvinces(List<ProvinceModel> list) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setListProvinces');
    try {
      return super.setListProvinces(list);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSuccessMessage(String? value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setSuccessMessage');
    try {
      return super.setSuccessMessage(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRememberMe(bool value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setRememberMe');
    try {
      return super.setRememberMe(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUploadLoading(bool value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setUploadLoading');
    try {
      return super.setUploadLoading(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadingProvinces(bool value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setLoadingProvinces');
    try {
      return super.setLoadingProvinces(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setToken(String newToken) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setToken');
    try {
      return super.setToken(newToken);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadSavedCredentials() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.loadSavedCredentials');
    try {
      return super.loadSavedCredentials();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listProvinces: ${listProvinces},
isLoading: ${isLoading},
isLoadingUpload: ${isLoadingUpload},
isLoadingProvince: ${isLoadingProvince},
isLoggedIn: ${isLoggedIn},
token: ${token},
errorMessage: ${errorMessage},
name: ${name},
email: ${email},
password: ${password},
isRememberMe: ${isRememberMe},
successMessage: ${successMessage},
userInfo: ${userInfo},
isFormValid: ${isFormValid},
hasError: ${hasError}
    ''';
  }
}

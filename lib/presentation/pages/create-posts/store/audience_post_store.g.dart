// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audience_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AudienceStore on _AudienceStore, Store {
  late final _$typeAudienceAtom =
      Atom(name: '_AudienceStore.typeAudience', context: context);

  @override
  String get typeAudience {
    _$typeAudienceAtom.reportRead();
    return super.typeAudience;
  }

  @override
  set typeAudience(String value) {
    _$typeAudienceAtom.reportWrite(value, super.typeAudience, () {
      super.typeAudience = value;
    });
  }

  late final _$typeAudienceIconAtom =
      Atom(name: '_AudienceStore.typeAudienceIcon', context: context);

  @override
  String get typeAudienceIcon {
    _$typeAudienceIconAtom.reportRead();
    return super.typeAudienceIcon;
  }

  @override
  set typeAudienceIcon(String value) {
    _$typeAudienceIconAtom.reportWrite(value, super.typeAudienceIcon, () {
      super.typeAudienceIcon = value;
    });
  }

  late final _$_AudienceStoreActionController =
      ActionController(name: '_AudienceStore', context: context);

  @override
  void setTypeAudience(String type) {
    final _$actionInfo = _$_AudienceStoreActionController.startAction(
        name: '_AudienceStore.setTypeAudience');
    try {
      return super.setTypeAudience(type);
    } finally {
      _$_AudienceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTypeAudienceIcon(String type) {
    final _$actionInfo = _$_AudienceStoreActionController.startAction(
        name: '_AudienceStore.setTypeAudienceIcon');
    try {
      return super.setTypeAudienceIcon(type);
    } finally {
      _$_AudienceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTypeAudienceIconPath(String imagePath) {
    final _$actionInfo = _$_AudienceStoreActionController.startAction(
        name: '_AudienceStore.setTypeAudienceIconPath');
    try {
      return super.setTypeAudienceIconPath(imagePath);
    } finally {
      _$_AudienceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleChangeTypeAudience(String type) {
    final _$actionInfo = _$_AudienceStoreActionController.startAction(
        name: '_AudienceStore.toggleChangeTypeAudience');
    try {
      return super.toggleChangeTypeAudience(type);
    } finally {
      _$_AudienceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
typeAudience: ${typeAudience},
typeAudienceIcon: ${typeAudienceIcon}
    ''';
  }
}

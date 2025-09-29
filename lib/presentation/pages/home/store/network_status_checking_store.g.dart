// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_status_checking_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NetworkStatusStore on _NetworkStatusStore, Store {
  late final _$isWifiAtom =
      Atom(name: '_NetworkStatusStore.isWifi', context: context);

  @override
  bool get isWifi {
    _$isWifiAtom.reportRead();
    return super.isWifi;
  }

  @override
  set isWifi(bool value) {
    _$isWifiAtom.reportWrite(value, super.isWifi, () {
      super.isWifi = value;
    });
  }

  late final _$isConnectedAtom =
      Atom(name: '_NetworkStatusStore.isConnected', context: context);

  @override
  bool get isConnected {
    _$isConnectedAtom.reportRead();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.reportWrite(value, super.isConnected, () {
      super.isConnected = value;
    });
  }

  late final _$is4GAtom =
      Atom(name: '_NetworkStatusStore.is4G', context: context);

  @override
  bool get is4G {
    _$is4GAtom.reportRead();
    return super.is4G;
  }

  @override
  set is4G(bool value) {
    _$is4GAtom.reportWrite(value, super.is4G, () {
      super.is4G = value;
    });
  }

  late final _$_NetworkStatusStoreActionController =
      ActionController(name: '_NetworkStatusStore', context: context);

  @override
  void _updateNetworkStatus(ConnectivityResult result) {
    final _$actionInfo = _$_NetworkStatusStoreActionController.startAction(
        name: '_NetworkStatusStore._updateNetworkStatus');
    try {
      return super._updateNetworkStatus(result);
    } finally {
      _$_NetworkStatusStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isWifi: ${isWifi},
isConnected: ${isConnected},
is4G: ${is4G}
    ''';
  }
}

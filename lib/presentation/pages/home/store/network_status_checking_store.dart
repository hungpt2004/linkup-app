import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'network_status_checking_store.g.dart';

class NetworkStatusStore = _NetworkStatusStore with _$NetworkStatusStore;

abstract class _NetworkStatusStore with Store {
  _NetworkStatusStore() {
    _init();
  }

  @observable
  bool isWifi = false;

  @observable
  bool isConnected = false;

  @observable
  bool is4G = false;

  @action
  void _updateNetworkStatus(ConnectivityResult result) {
    isWifi = result == ConnectivityResult.wifi;
    isConnected = result != ConnectivityResult.none;
    debugPrint('Network status updated - Connected: $isConnected, WiFi: $isWifi');
  }

  void _init() async {
    // Check initial connectivity state
    final results = await Connectivity().checkConnectivity();
    debugPrint('Initial connectivity check results: $results');
    final mainResult =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    _updateNetworkStatus(mainResult);

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((results) {
      debugPrint('Connectivity changed, new results: $results');
      final mainResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateNetworkStatus(mainResult);
    });
  }
}
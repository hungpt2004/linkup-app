import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/store/store_factory.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final Completer<bool> _initialized = Completer<bool>();

  bool get isInitialized => _initialized.isCompleted;

  /// Initialize the deep link service
  Future<void> init() async {
    try {
      _appLinks = AppLinks();

      // Handle incoming links
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          StoreFactory.deepLinkStore.handleDeepLink(uri);
        },
        onError: (err) {
          debugPrint('DeepLinkService: Error occurred: $err');
        },
      );

      // Handle initial link if app was started from a deep link
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        StoreFactory.deepLinkStore.handleDeepLink(initialLink);
      }

      _initialized.complete(true);
      debugPrint('DeepLinkService: Initialized successfully');
    } catch (e) {
      debugPrint('DeepLinkService: Initialization failed: $e');
      _initialized.complete(false);
    }
  }

  /// Dispose of the service
  void dispose() {
    _linkSubscription?.cancel();
  }
}

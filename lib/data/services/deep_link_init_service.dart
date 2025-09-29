import 'package:flutter/material.dart';
import 'package:vdiary_internship/data/services/deep_link_service.dart';
import 'package:vdiary_internship/presentation/pages/posts/store/deep_link_store.dart';

// SINGLETON DEEPLINK SERVICE
class DeepLinkInitService {
  static final DeepLinkStore deepLinkStore = DeepLinkStore();

  /// Initialize deep link service
  static Future<void> init() async {
    try {
      // Initialize the deep link service
      await DeepLinkService().init();
      debugPrint('DeepLinkInitService: Deep link service initialized');
    } catch (e) {
      debugPrint(
        'DeepLinkInitService: Failed to initialize deep link service: $e',
      );
    }
  }
}

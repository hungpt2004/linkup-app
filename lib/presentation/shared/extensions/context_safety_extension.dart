import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/presentation/shared/store/store_provider.dart';

/// Extension để safe access stores với context validation
extension ContextSafetyExt on BuildContext {
  /// Kiểm tra context có còn valid và có StoreProvider không
  bool get isContextValid {
    try {
      // Kiểm tra widget còn mounted
      if (this is Element) {
        final element = this as Element;
        if (!element.mounted) return false;
      }

      // Kiểm tra có StoreProvider không
      final provider = StoreProvider.maybeOf(this);
      return provider != null;
    } catch (e) {
      debugPrint('Context validation error: $e');
      return false;
    }
  }

  /// Safe access đến StoreProvider, trả về null nếu context invalid
  StoreProvider? get safeStoreProvider {
    if (!isContextValid) return null;
    return StoreProvider.maybeOf(this);
  }

  /// Helper method để safely execute code với store context
  T? safelyUseStore<T>(T Function(StoreProvider provider) callback) {
    try {
      final provider = safeStoreProvider;
      if (provider == null) {
        debugPrint('❌ StoreProvider not available in current context');
        return null;
      }
      return callback(provider);
    } catch (e) {
      debugPrint('❌ Error using store: $e');
      return null;
    }
  }

  /// Safe navigation helper
  void safeNavigate(void Function() navigationAction) {
    if (isContextValid) {
      try {
        navigationAction();
      } catch (e) {
        debugPrint('❌ Navigation error: $e');
      }
    } else {
      debugPrint('❌ Cannot navigate: context is invalid');
    }
  }
}

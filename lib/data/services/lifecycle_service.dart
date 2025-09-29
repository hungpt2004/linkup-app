import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/store/store_provider.dart';
import 'local_notification_service.dart';

class LifecycleService {
  final BuildContext context;

  LifecycleService({required this.context});

  Future<void> onBackground() async {
    // Kiểm tra StoreProvider đã có trong widget tree chưa
    if (StoreProvider.maybeOf(context) == null) {
      debugPrint('StoreProvider chưa sẵn sàng, bỏ qua onBackground');
      return;
    }

    await context.lifeCycleStore.setBackground();
    await context.postStore.cacheTopPostsToHive();
    debugPrint('ĐANG ON BACKGROUND');
    await NotificationService().showNotification("Ứng dụng vào background");
  }

  Future<void> onForeground() async {
    // Kiểm tra StoreProvider đã có trong widget tree chưa
    if (StoreProvider.maybeOf(context) == null) {
      debugPrint('StoreProvider chưa sẵn sàng, bỏ qua onForeground');
      return;
    }

    context.lifeCycleStore.setForeground();
    await context.postStore.loadPostsFromHive();

    // Check wifi
    final isWifi = context.netWorkStore.isWifi;

    if (isWifi == false && !context.postStore.isLoadedFromCache) {
      debugPrint("Không có dữ liệu vì ngay từ đầu đã không có wifi");
    }

    // Nếu không có cache, load từ API
    if (!context.postStore.isLoadedFromCache) {
      debugPrint('No cache found, loading from API');
      await context.postStore.loadPosts(refresh: true);
    } else {
      debugPrint('Loaded from cache, skip API load for now');
      // Có thể thêm logic refresh sau một thời gian
    }

    debugPrint('ĐANG ON FOREGROUND');
    await NotificationService().showNotification(
      "Ứng dụng quay lại foreground",
    );
  }
}

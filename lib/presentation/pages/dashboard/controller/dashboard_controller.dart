import 'package:mobx/mobx.dart';

part 'dashboard_controller.g.dart';

// ignore: library_private_types_in_public_api
class DashboardController = _DashboardController with _$DashboardController;

abstract class _DashboardController with Store {
  // Observable states
  @observable
  int currentPageIndex = 0;

  @observable
  bool isDrawerOpen = false;

  @observable
  ObservableList<Map<String, dynamic>> notifications =
      ObservableList<Map<String, dynamic>>();

  @observable
  bool hasUnreadNotifications = false;

  @observable
  String? errorMessage;

  // Actions
  @action
  void setCurrentPage(int index) {
    currentPageIndex = index;
  }

  @action
  void setDrawerState(bool isOpen) {
    isDrawerOpen = isOpen;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  // Navigation methods
  @action
  void navigateToHome() {
    setCurrentPage(0);
  }

  @action
  void navigateToFriends() {
    setCurrentPage(1);
  }

  @action
  void navigateToFriendActions() {
    setCurrentPage(2);
  }

  @action
  void navigateToSuggestions() {
    setCurrentPage(3);
  }

  // Drawer methods
  @action
  void openDrawer() {
    setDrawerState(true);
  }

  @action
  void closeDrawer() {
    setDrawerState(false);
  }

  @action
  void toggleDrawer() {
    setDrawerState(!isDrawerOpen);
  }

  // Notifications
  @action
  Future<void> loadNotifications() async {
    try {
      clearError();

      // final response = await apiService.getNotifications();

      // Mock implementation
      await Future.delayed(Duration(milliseconds: 500));
      notifications.clear();
      notifications.addAll([
        {
          'id': 1,
          'type': 'friend_request',
          'title': 'Lời mời kết bạn',
          'message':
              'Châu Đức và Hương Hồng đã chấp nhận lời mời kết bạn của bạn',
          'avatars': [
            'https://i.pinimg.com/736x/3f/18/28/3f1828dd47ac78756c5957fcb57c3849.jpg',
            'https://i.pinimg.com/736x/4b/59/84/4b5984d18e93691f3ba7d894aefec9af.jpg',
            'https://i.pinimg.com/736x/cb/4e/64/cb4e645d958ad62a7a2aed5209d56487.jpg',
          ],
          'createdAt': DateTime.now().subtract(Duration(minutes: 30)),
          'isRead': false,
        },
        {
          'id': 2,
          'type': 'like',
          'title': 'Thích bài viết',
          'message': 'Nguyễn Văn A đã thích bài viết của bạn',
          'avatars': [
            'https://i.pinimg.com/736x/3f/18/28/3f1828dd47ac78756c5957fcb57c3849.jpg',
          ],
          'createdAt': DateTime.now().subtract(Duration(hours: 2)),
          'isRead': true,
        },
      ]);

      hasUnreadNotifications = notifications.any(
        (notification) => !notification['isRead'],
      );
    } catch (e) {
      setError('Không thể tải thông báo: ${e.toString()}');
    }
  }

  @action
  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      // await apiService.markNotificationAsRead(notificationId);

      // Mock implementation
      await Future.delayed(Duration(milliseconds: 200));

      final index = notifications.indexWhere(
        (notification) => notification['id'] == notificationId,
      );
      if (index != -1) {
        notifications[index] = {...notifications[index], 'isRead': true};

        // Update unread status
        hasUnreadNotifications = notifications.any(
          (notification) => !notification['isRead'],
        );
      }

      return true;
    } catch (e) {
      setError('Không thể đánh dấu thông báo: ${e.toString()}');
      return false;
    }
  }

  @action
  Future<bool> markAllNotificationsAsRead() async {
    try {
      // await apiService.markAllNotificationsAsRead();

      // Mock implementation
      await Future.delayed(Duration(milliseconds: 300));

      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = {...notifications[i], 'isRead': true};
      }

      hasUnreadNotifications = false;
      return true;
    } catch (e) {
      setError('Không thể đánh dấu tất cả thông báo: ${e.toString()}');
      return false;
    }
  }

  @action
  Future<bool> deleteNotification(int notificationId) async {
    try {
      // await apiService.deleteNotification(notificationId);

      // Mock implementation
      await Future.delayed(Duration(milliseconds: 200));
      notifications.removeWhere(
        (notification) => notification['id'] == notificationId,
      );

      // Update unread status
      hasUnreadNotifications = notifications.any(
        (notification) => !notification['isRead'],
      );
      return true;
    } catch (e) {
      setError('Không thể xóa thông báo: ${e.toString()}');
      return false;
    }
  }

  // Computed values
  @computed
  String get currentPageName {
    switch (currentPageIndex) {
      case 0:
        return 'Trang chủ';
      case 1:
        return 'Tất cả bạn bè';
      case 2:
        return 'Hoạt động bạn bè';
      case 3:
        return 'Gợi ý kết bạn';
      default:
        return 'Trang chủ';
    }
  }

  @computed
  bool get isHomePage => currentPageIndex == 0;

  @computed
  bool get isFriendsPage => currentPageIndex == 1;

  @computed
  bool get isFriendActionsPage => currentPageIndex == 2;

  @computed
  bool get isSuggestionsPage => currentPageIndex == 3;

  @computed
  int get unreadNotificationsCount =>
      notifications.where((notification) => !notification['isRead']).length;

  @computed
  List<Map<String, dynamic>> get unreadNotifications =>
      notifications.where((notification) => !notification['isRead']).toList();

  @computed
  bool get hasError => errorMessage != null;

  // Initialize dashboard
  @action
  Future<void> initialize() async {
    await loadNotifications();
  }

  // Helper method for navigation with drawer close
  @action
  void navigateToPage(int index) {
    setCurrentPage(index);
    closeDrawer();
  }
}

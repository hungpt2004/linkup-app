import 'package:mobx/mobx.dart';

part 'navigation_controller.g.dart';

// ignore: library_private_types_in_public_api
class NavigationStore = _NavigationStore with _$NavigationStore;

abstract class _NavigationStore with Store {
  @observable
  int currentPageIndex = 0;

  @observable
  bool isDrawerOpen = false;

  @action
  void setCurrentPage(int index) {
    currentPageIndex = index;
  }

  @action
  void openDrawer() {
    isDrawerOpen = true;
  }

  @action
  void closeDrawer() {
    isDrawerOpen = false;
  }

  @action
  void toggleDrawer() {
    isDrawerOpen = !isDrawerOpen;
  }

  @computed
  String get currentPageTitle {
    switch (currentPageIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'All Friends';
      case 2:
        return 'Friends';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profiles';
      default:
        return 'VDiary';
    }
  }
}

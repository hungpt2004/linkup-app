import 'package:mobx/mobx.dart';

part 'app_lifecycle_store.g.dart';

class AppLifecycleStore = _AppLifecycleStore with _$AppLifecycleStore;

enum AppLifecycleStatus { foreground, background }

abstract class _AppLifecycleStore with Store {
  @observable
  AppLifecycleStatus status = AppLifecycleStatus.foreground;

  @action
  Future<void> setForeground() async {
    status = AppLifecycleStatus.foreground;
  }

  @action
  Future<void> setBackground() async {
    status = AppLifecycleStatus.background;
  }
}

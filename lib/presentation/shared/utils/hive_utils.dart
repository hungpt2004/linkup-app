import 'package:hive/hive.dart';

class HiveUtils {
  static Future<Box<T>> openBoxSafely<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final existingBox = Hive.box(boxName);
      if (existingBox is Box<T>) {
        return existingBox;
      } else {
        await existingBox.close();
      }
    }

    // Open the box with the correct type
    return await Hive.openBox<T>(boxName);
  }

  /// Closes a Hive box if it's open
  static Future<void> closeBoxSafely(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      await box.close();
    }
  }
}

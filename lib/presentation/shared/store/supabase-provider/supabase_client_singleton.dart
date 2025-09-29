import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSingleton {
  static final SupabaseSingleton _instance = SupabaseSingleton._internal();
  late final SupabaseClient client;

  factory SupabaseSingleton() {
    return _instance;
  }

  SupabaseSingleton._internal();

  /// Khởi tạo Supabase (gọi 1 lần trong main.dart)
  static Future<void> init({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    _instance.client = Supabase.instance.client;
  }
}

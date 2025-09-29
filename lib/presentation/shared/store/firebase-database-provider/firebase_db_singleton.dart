import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseProvider {
  static final FirebaseDatabaseProvider _instance =
      FirebaseDatabaseProvider._internal();
  late final FirebaseDatabase _database;

  factory FirebaseDatabaseProvider() {
    return _instance;
  }

  FirebaseDatabaseProvider._internal() {
    _database = FirebaseDatabase.instance;
  }

  DatabaseReference ref([String? path]) {
    return path != null ? _database.ref(path) : _database.ref();
  }

  FirebaseDatabase get instance => _database;
}

// Khi dùng chỉ cần gọi

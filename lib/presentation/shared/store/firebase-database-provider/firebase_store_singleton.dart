import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreProvider {
  static final FirebaseFirestoreProvider _instance = FirebaseFirestoreProvider._internal();
  late final FirebaseFirestore _firestore;

  factory FirebaseFirestoreProvider() {
    return _instance;
  }

  FirebaseFirestoreProvider._internal() {
    _firestore = FirebaseFirestore.instance;
  }

  /// Lấy collection ref
  CollectionReference<Map<String, dynamic>> col(String path) {
    return _firestore.collection(path);
  }

  /// Lấy document ref
  DocumentReference<Map<String, dynamic>> doc(String path) {
    return _firestore.doc(path);
  }

  FirebaseFirestore get instance => _firestore;
}

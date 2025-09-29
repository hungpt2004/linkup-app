import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/shared/store/firebase-database-provider/firebase_db_singleton.dart';

class PresenceService {
  final _db = FirebaseDatabaseProvider();

  Future<void> setupPresence(String userId) async {
    debugPrint('🔥 Setting up presence for path: status/$userId');
    final userStatusRef = _db.ref('status/$userId');
    final connectedRef = _db.ref('.info/connected');

    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;

      if (!connected) return;

      userStatusRef
          .onDisconnect()
          .set({'state': 'offline', 'last_changed': ServerValue.timestamp})
          .then((_) {
            debugPrint('User $userId set to OFFLINE on disconnect');

            // Delay nhỏ để tránh race condition
            return Future.delayed(Duration(milliseconds: 100));
          })
          .then((_) {
            return userStatusRef.set({
              'state': 'online',
              'last_changed': ServerValue.timestamp,
            });
          })
          .then((_) {
            debugPrint('User $userId set to ONLINE');
          });
    });
  }

  Future<void> setOfflineStatus(String userId) async {
    debugPrint('🔥 Setting offline for path: status/$userId');
    final userStatusRef = _db.ref('status/$userId');

    return userStatusRef
        .set({'state': 'offline', 'last_changed': ServerValue.timestamp})
        .then((_) {
          debugPrint('User $userId manually set to OFFLINE');
        });
  }

  // Lắng nghe trạng thái của các user khác
  Stream<Map<String, dynamic>?> listenToUserStatus(String userId) {
    final ref = _db.ref('status/$userId');
    return ref.onValue.map((event) {
      if (event.snapshot.value == null) return null;
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }
}

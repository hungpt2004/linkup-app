import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vdiary_internship/core/constants/api/end_point.dart'
    show baseSocketUrl;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;
  bool _isConnected = false;

  SocketService._internal();

  void connect(String userId) {
    if (_socket != null && _isConnected) {
      debugPrint("Socket đã kết nối, không cần connect lại");
      return;
    }

    _socket = IO.io(baseSocketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.on('connect', (_) {
      _isConnected = true;
      debugPrint('Connected to socket server');
      _socket!.emit('registerUser', userId);
    });

    _socket!.on('disconnect', (_) {
      _isConnected = false;
      debugPrint('Socket disconnected');
    });

    _socket!.on('connect_error', (error) {
      debugPrint('Socket connection error: $error');
    });
  }

  IO.Socket? get socket => _socket;

  // ===== Các hàm tiện ích tái sử dụng =====
  void joinPost(String postId) {
    emit("joinPost", {"postId": postId});
  }

  void leavePost(String postId) {
    emit("leavePost", {"postId": postId});
  }

  void sendMessage(String postId, String message) {
    emit("sendMessage", {"postId": postId, "message": message});
  }

  void emit(String event, dynamic data) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
    } else {
      debugPrint("Socket chưa kết nối, không thể emit");
    }
  }

  void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      _socket!.on(event, callback);
    }
  }

  void off(String event) {
    _socket?.off(event);
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }
}

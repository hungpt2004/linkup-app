import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(dynamic date) {
  if (date is DateTime) {
    return '${date.day}/${date.month}/${date.year}';
  }
  if (date is String) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return date;
    }
  }
  return '';
}

String formatDatePost(String dateStr) {
  try {
    // Nếu dateStr là ISO 8601: "2025-09-29T12:49:34.314948Z"
    DateTime date = DateTime.parse(dateStr).toLocal();

    return DateFormat("dd/MM/yyyy HH:mm").format(date);
  } catch (e) {
    return "Invalid date format";
  }
}

String formatDateMessage(String dateStr) {
  try {
    // Parse chuỗi theo pattern gốc
    DateTime date =
        DateFormat(
          "h:mm:ss a 'UTC'xxx",
        ).parse(dateStr, true).toLocal(); // chuyển về local time

    // Format lại theo yêu cầu
    return DateFormat("HH:mm").format(date);
  } catch (e) {
    return "Invalid date format";
  }
}

String formatTimeAgo(dynamic date) {
  if (date == null || date.toString().isEmpty) {
    return ''; // Hoặc một giá trị mặc định phù hợp
  }

  try {
    final postDateTime = DateTime.parse(date.toString());
    final now = DateTime.now(); // Sử dụng thời gian địa phương
    final diff = now.difference(postDateTime);

    // Xử lý trường hợp thời gian bị lệch
    if (diff.isNegative) {
      return 'now';
    }

    if (diff.inSeconds < 60) {
      // Dưới 1 phút thì hiển thị 'now' để thân thiện với người dùng hơn
      return 'now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d';
    }
    if (diff.inDays < 30) {
      final w = diff.inDays ~/ 7;
      return '${w}w';
    }
    if (diff.inDays < 365) {
      // final mo = diff.inDays ~/ 30;
      return formatDate(diff.toString());
    }
    final y = diff.inDays ~/ 365;
    return '${y}y';
  } on FormatException {
    return 'Invalid Date';
  }
}

/// Format Firestore Timestamp to HH:mm format
String formatTimestampToTime(Timestamp timestamp) {
  try {
    final dateTime = timestamp.toDate();
    return DateFormat("HH:mm").format(dateTime);
  } catch (e) {
    return "--:--";
  }
}

/// Format dynamic date input (supports Timestamp, DateTime, String) to HH:mm format
String formatMessageTime(dynamic date) {
  try {
    if (date is Timestamp) {
      return formatTimestampToTime(date);
    } else if (date is DateTime) {
      return DateFormat("HH:mm").format(date);
    } else if (date is String) {
      // Try parsing as ISO string first
      try {
        final dt = DateTime.parse(date);
        return DateFormat("HH:mm").format(dt);
      } catch (_) {
        // Fallback to original string format parsing
        return formatDateMessage(date);
      }
    }
    return "--:--";
  } catch (e) {
    return "--:--";
  }
}

String formatLastSeen(int lastChangedMillis) {
  final lastChanged = DateTime.fromMillisecondsSinceEpoch(lastChangedMillis);
  final diff = DateTime.now().difference(lastChanged);
  debugPrint('Last changed: $lastChanged');
  debugPrint('Diff: $diff');
  if (diff.inSeconds < 60) {
    return "5s";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes}m";
  } else if (diff.inHours < 24) {
    return "${diff.inHours}h";
  } else {
    return "${diff.inDays}d";
  }
}

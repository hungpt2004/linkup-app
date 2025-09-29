import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter/rendering.dart';
// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadSupabaseService {
  final SupabaseClient supabase;
  final String bucketName;

  UploadSupabaseService(this.supabase, this.bucketName);

  /// Upload 1 file -> trả về public URL
  Future<String?> uploadFile(File file, {String? path}) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final fullPath = path != null ? '$path/$fileName' : fileName;

      // Detect MIME type (image/jpeg, video/mp4, ...)
      final mimeType = lookupMimeType(file.path);

      await supabase.storage
          .from(bucketName)
          .upload(
            fullPath,
            file,
            fileOptions: FileOptions(contentType: mimeType),
          );

      return supabase.storage.from(bucketName).getPublicUrl(fullPath);
    } catch (e) {
      debugPrint('❌ Upload error: $e');
      return null;
    }
  }

  /// Upload nhiều file -> trả về danh sách public URL
  Future<List<String>> uploadMultipleFiles(
    List<File> files, {
    String? path,
  }) async {
    List<String> urls = [];

    for (var file in files) {
      final url = await uploadFile(file, path: path);
      if (url != null) urls.add(url);
    }

    return urls;
  }

  /// Xóa file theo path
  Future<bool> deleteFile(String path) async {
    try {
      await supabase.storage.from(bucketName).remove([path]);
      return true;
    } catch (e) {
      debugPrint('❌ Delete error: $e');
      return false;
    }
  }

  /// Lấy public URL nếu biết path
  String getPublicUrl(String path) {
    return supabase.storage.from(bucketName).getPublicUrl(path);
  }

  /// Download file từ Supabase Storage -> lưu local -> trả về File
  Future<File?> downloadFile(String path, String savePath) async {
    try {
      final data = await supabase.storage.from(bucketName).download(path);
      final file = File(savePath);
      await file.writeAsBytes(data);
      return file;
    } catch (e) {
      debugPrint('❌ Download error: $e');
      return null;
    }
  }
}

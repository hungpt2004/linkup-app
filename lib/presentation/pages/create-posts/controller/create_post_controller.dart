import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/store/create_post_store.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/store/tag_people_post_store.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/utils/hashtag_utils.dart';
import 'package:vdiary_internship/data/models/post/link_model.dart';
import 'package:vdiary_internship/presentation/pages/home/store/network_status_checking_store.dart';
import 'package:vdiary_internship/presentation/pages/notification/store/notification_store.dart';
import 'package:vdiary_internship/presentation/shared/extensions/bottom_sheet_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class CreatePostController {
  final CreatePostStore createStore;
  final TagUserStore tagUserStore;
  final NotificationStore notificationStore;
  final NetworkStatusStore networkStatusStore;

  CreatePostController({
    required this.notificationStore,
    required this.tagUserStore,
    required this.networkStatusStore,
    required this.createStore,
  });

  // Text editing controllers
  final TextEditingController captionController = TextEditingController();

  void dispose() {
    captionController.dispose();
  }

  void clearAllMedia() {
    createStore.clearSelectedMedia();
  }

  // Content management
  void addHashtag(String hashtag) {
    final tag = hashtag.startsWith('#') ? hashtag.substring(1) : hashtag;
    if (tag.isNotEmpty) {
      createStore.addHashtag(tag);
    }
  }

  // Lấy danh sách userId của các mention để gửi API
  List<String> getMentionUserIds() {
    if (tagUserStore.selectedUserInfor.isNotEmpty) {
      return tagUserStore.selectedUserInfor
          .map((u) => u.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }
    return [];
  }

  // BottomSheet sử dụng MIC
  void showMicSettingsBottomSheet(BuildContext context) {
    context.showBottomSheet(
      text: 'Microphone Settings',
      height: ResponsiveSizeApp(context).screenHeight * 0.8,
      child: Column(
        children: [
          HSpacing(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Voice Assistant Features',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enable microphone access to unlock powerful voice features that help you create engaging content faster and more efficiently.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.mic, color: Colors.green.shade600, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Voice-to-text for instant caption creation',
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          HSpacing(20),
          Observer(
            builder: (_) {
              final store = createStore;
              final micEnable = store.isMicEnabled;
              return CheckboxListTile(
                title: const Text('Enable Microphone'),
                subtitle: const Text('Allow use mic support to build caption'),
                value: micEnable,
                onChanged: (bool? value) {
                  createStore.setMicEnabled(value ?? false);
                },
                controlAffinity: ListTileControlAffinity.trailing,
              );
            },
          ),
          HSpacing(20),
        ],
      ),
    );
  }

  // Bottom Sheet để chọn AI hỗ trợ

  // Post creation
  Future<bool> createPost() async {
    createStore.clearError();

    // Check valid content
    final content = captionController.text.trim();
    if (content.isEmpty && !createStore.hasMedia) {
      createStore.setError('Vui lòng nhập nội dung hoặc chọn ảnh/video');
      return false;
    }

    // Check valid media file
    if (!validateMediaFiles()) {
      return false;
    }

    // Extract hashtags from caption
    final hashtags = extractHashtagsFromText(content);
    createStore.setHashtags(hashtags);

    // Extract links from caption and set to store as LinkModel
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlRegExp.allMatches(content);
    final links =
        matches
            .map((m) => m.group(0))
            .where((url) => url != null && url.isNotEmpty)
            .map((url) => LinkModel(url: url!))
            .toList();
    createStore.setLinks(links);

    // Set caption post
    createStore.setCaption(content);

    // Create post data
    final postData = {'content': content};
    final isWifi = networkStatusStore.isWifi;

    // Hàm trả về giá trị bool
    return await createStore.createPost(isWifi, postData);
  }

  // Submit post with UI handling
  Future<bool> submitPost(BuildContext context) async {
    if (!createStore.canPost) {
      return false;
    }

    try {
      createStore.setLoading(true);

      // Create post API action
      final success = await createPost();

      // Reset lại form
      resetForm();

      return success;
    } catch (e) {
      createStore.setError('Lỗi khi tạo bài viết: ${e.toString()}');
      return false;
    } finally {
      createStore.setLoading(false);
    }
  }

  // Form reset
  void resetForm() {
    captionController.clear();
    createStore.resetForm();
  }

  // Media validation
  bool validateMediaFiles() {
    // Check if any selected files exist
    for (String path in createStore.selectedImagePaths) {
      if (!File(path).existsSync()) {
        createStore.setError('Một số file ảnh không tồn tại');
        return false;
      }
    }

    for (String path in createStore.selectedVideoPaths) {
      if (!File(path).existsSync()) {
        createStore.setError('Một số file video không tồn tại');
        return false;
      }
    }

    return true;
  }
}

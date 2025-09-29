import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vdiary_internship/presentation/pages/auth/store/auth_store.dart';
import 'package:vdiary_internship/presentation/pages/profile/store/profile_post_store.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';

class ProfileController {
  AuthStore authStore;
  ProfilePostStore profilePostStore;

  ProfileController(this.authStore, this.profilePostStore);

  // Hàm chọn ảnh
  Future<String?> pickAndCropImage({required bool fromCamera}) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) return null;

      // Cắt ảnh
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        // aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Avatar',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Avatar', aspectRatioLockEnabled: true),
        ],
      );
      return croppedFile?.path;
    } catch (error) {
      return null;
    }
  }

  // Hàm lấy post dựa theo userId
  Future<void> findPostByUserId({required String userId}) async {
    try {
      debugPrint("🔄 ProfileController: Finding posts for userId: $userId");

      final success = await profilePostStore.loadUserPosts(
        userId: userId,
        refresh: true, // Chỉ dùng refresh, không dùng loadMore cùng lúc
      );

      if (success) {
        debugPrint("✅ Lấy dữ liệu post theo $userId THÀNH CÔNG ");
      } else {
        debugPrint("❌ Lấy dữ liệu post theo $userId THẤT BẠI ");
      }
    } catch (error) {
      debugPrint('❌ Error when find post by userId: ${error.toString()}');
    }
  }

  // Upload avatar và background
  Future<void> uploadAvatar(
    String imagePath,
    BuildContext context,
    String type,
  ) async {
    try {
      bool success = false;
      if (type == 'avatar') {
        success = await authStore.uploadAvatar(imagePath);
      } else if (type == 'background') {
        success = await authStore.uploadBackground(imagePath);
      }
      if (success) {
        if (context.mounted) {
          await authStore.getProfileUser();
          // ignore: use_build_context_synchronously
          ToastAppWidget.showSuccessToast(context, 'Upload $type success');
        }
      } else if (authStore.isLoadingUpload == true) {
        if (context.mounted) {
          ToastAppWidget.showLoadingToast(context, 'Loading...');
        }
      }
    } catch (error) {
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, error.toString());
      }
    }
  }
}

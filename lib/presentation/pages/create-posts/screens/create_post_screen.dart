import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/bottom_sheet_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

// RELATIVE IMPORT
import '../widgets/audience_option_bottomsheet.dart';
import '../widgets/tag_people_option_bottomsheet.dart';
import '../widgets/layout/form_post_layout.dart';
import '../widgets/image_option_section_widget.dart';

// Import for Post model
import 'package:vdiary_internship/data/models/post/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  final PostModel? editPost;
  final bool isEditMode;

  const CreatePostScreen({super.key, this.editPost, this.isEditMode = false});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final TextEditingController _contentController;
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;
  final String createPostMode = 'Create Post';
  final String editPostMode = 'Edit Post';
  final String titleCreateButton = 'Post';
  final String titleUpdateButton = 'Update';

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final createPostStore = context.createPostStore;

      // Initialize stores
      createPostStore.setStores(
        context.audienceStore,
        context.tagUserStore,
        context.postStore,
        context.netWorkStore,
      );

      // Clear all existing data first
      createPostStore.clearAll();

      // Pre-populate form if in edit mode
      if (widget.isEditMode && widget.editPost != null) {
        _contentController.text = widget.editPost!.caption;
        createPostStore.setCaption(widget.editPost!.caption);

        // Load existing images
        for (String imagePath in widget.editPost!.images) {
          createPostStore.addImagePath(imagePath);
        }

        // Load existing videos
        for (String videoPath in widget.editPost!.videos) {
          createPostStore.addVideoPath(videoPath);
        }
      } else {
        // Set initial text for create mode
        _contentController.text = createPostStore.caption;
      }

      _contentController.addListener(() {
        final currentText = _contentController.text;
        createPostStore.setCaption(currentText);
      });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    // Clear store data when leaving screen
    if (mounted) {
      context.createPostStore.dispose();
      context.tagUserStore.clearSelectedUserInfor();
    }
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickMediaFromGallery() async {
    context.showCustomDialog(
      height: 280,
      subtitle: 'You can choose your source media',
      showCloseButton: true,
      title: 'Source Media',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PickImageOptionWidget(
            titleOption: 'Pick Image from Gallery',
            functionOption: () async {
              Navigator.pop(context); // Tắt hộp thoại
              await _pickImageFromGallery();
            },
            iconOption: ImagePath.photoIcon,
          ),
          PickImageOptionWidget(
            titleOption: 'Take by Camera',
            functionOption: () async {
              Navigator.pop(context); // Tắt hộp thoại
              await _pickImageFromCamera();
            },
            iconOption: ImagePath.cameraIcon,
          ),
          PickImageOptionWidget(
            titleOption: 'Pick Video from Gallery',
            functionOption: () async {
              Navigator.pop(context); // Tắt hộp thoại
              await _pickVideoFromGallery();
            },
            iconOption: ImagePath.liveVideoIcon,
          ),
        ],
      ),
    );
  }

  // Hàm chọn nhiều ảnh
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);
    // ignore: use_build_context_synchronously
    final createPostStore = context.createPostStore;
    if (images.isNotEmpty) {
      for (var e in images) {
        createPostStore.addImagePath(e.path);
      }
    }
  }

  // Hàm chọn nhiều video
  Future<void> _pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> videos =
        await picker.pickMultipleMedia(); // Hoặc pickVideo nếu chỉ muốn 1 video
    // ignore: use_build_context_synchronously
    final createPostStore = context.createPostStore;
    if (videos.isNotEmpty) {
      for (var e in videos) {
        createPostStore.addVideoPath(e.path);
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      // ignore: use_build_context_synchronously
      final createPostStore = context.createPostStore;
      createPostStore.addImagePath(image.path);
    }
  }

  // Hàm chọn audience
  void _showAudienceSetting() {
    context.showBottomSheet(
      backgroundColor: Colors.white,
      text: 'Choose Audience',
      height: MediaQuery.of(context).size.height,
      isScrollControlled: true,
      borderRadius: 15,
      child: FormAudienceBottomSheet(
        richTextBaseStyle: context.textTheme.bodySmall!,
      ),
    );
  }

  // Hàm chọn tag người
  void _showTagPeopleSetting() {
    context.showBottomSheet(
      child: FormTagPeopleBottomSheet(
        onTap: () {},
        searchController: _searchController,
      ),
      text: 'Tag People',
      backgroundColor: Colors.white,
      height: MediaQuery.of(context).size.height,
      isScrollControlled: true,
    );
  }

  // Hàm chọn post option
  void _handlePostOptionTap(BuildContext context, String type) {
    switch (type) {
      case 'photo':
        _pickMediaFromGallery();
        break;
      case 'tag':
        _showTagPeopleSetting();
        break;
      case 'audience':
        _showAudienceSetting();
        break;
      default:
        break;
    }
  }

  void _onTapSetting() {
    _showAudienceSetting();
  }

  void _submitPost() async {
    final createPostStore = context.createPostStore;

    if (!createPostStore.canPost) {
      return;
    }

    try {
      final currentContent = _contentController.text.trim();
      createPostStore.setCaption(currentContent);

      createPostStore.setLoading(true);

      bool success;
      if (widget.isEditMode && widget.editPost != null) {
        final postStore = context.postStore;
        final updateData = {
          'caption': currentContent,
          'images': createPostStore.selectedImagePaths,
          'videos': createPostStore.selectedVideoPaths,
        };
        success = await postStore.updatePost(widget.editPost!.id, updateData);
      } else {
        final postData = {'content': currentContent};
        success = await createPostStore.createPost(
          context.netWorkStore.isWifi,
          context.authStore.userInfo,
          postData,
        );
      }

      if (success) {
        _contentController.clear();
        createPostStore.clearAll();
        // ignore: use_build_context_synchronously
        context.tagUserStore.clearSelectedUserInfor();

        // notification logic
        final userInfor = context.authStore.userInfo;
        final currentUserId = userInfor?['_id'] ?? '';
        final currentUserName = userInfor?['email'] ?? '';
        final currentAvatar = userInfor?['avatar'] ?? '';
        final currentFullname = userInfor?['name'] ?? '';
        final userEntity = UserEntity(
          id: currentUserId,
          username: currentUserName,
          avatar: currentAvatar,
          fullname: currentFullname,
        );

        // Tạo thông báo post bài mới
        // ignore: use_build_context_synchronously
        context.notificationStore.createNotification(
          authorInformation: userEntity,
          referenceId: '',
          // ignore: use_build_context_synchronously
          friends: context.friendStore.friends,
          actionAuthorId: currentUserId,
          contentNotification: '${userEntity.fullname} vừa đăng post mới',
          typeNotification: TypeNotification.post.name,
          deepLink: 'socialapp/post/dashboard/',
        );

        // Show success toast based on mode
        final successMessage =
            widget.isEditMode
                ? 'Post updated successfully'
                : 'Post created successfully';

        // Show toast message
        if (mounted) {
          ToastAppWidget.showSuccessToast(context, successMessage);
        }

        // Điều hướng về HomePage
        Future.delayed(Duration(milliseconds: 1000), () {
          if (mounted) {
            AppNavigator.toDashboard(context, tabIndex: 0);
          }
        });

        // Refresh post sau 2s
        // Future.delayed(Duration(milliseconds: 2000), () {
        //   if (mounted) {
        //     try {
        //       final postStore = context.postStore;
        //       postStore.refresh();
        //     } catch (e) {
        //       debugPrint('Failed to refresh posts: $e');
        //     }
        //   }
        // });
      } else {
        if (mounted) {
          final errorMessage =
              widget.isEditMode ? 'Update post failed' : 'Create post failed';
          ToastAppWidget.showErrorToast(context, errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        ToastAppWidget.showErrorToast(context, e.toString());
      }
    } finally {
      if (mounted) {
        Future.delayed(
          Duration(seconds: 2),
          () => createPostStore.setLoading(false),
        );
      }
    }
  }

  void _removeImage(int index) {
    context.createPostStore.removeImagePath(index);
  }

  void _removeVideo(int index) {
    context.createPostStore.removeVideoPath(index);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final createPostStore = context.createPostStore;
        return FormPostLayout(
          onTap: _onTapSetting,
          contentController: _contentController,
          onOptionTap: (type) => _handlePostOptionTap(context, type),
          imagePaths: createPostStore.selectedImagePaths,
          videoPaths: createPostStore.selectedVideoPaths,
          onAddImage: _pickMediaFromGallery,
          onRemoveImage: _removeImage,
          onRemoveVideo: _removeVideo,
          appBarOnPost: createPostStore.canPost ? _submitPost : null,
          appBarTitle: widget.isEditMode ? editPostMode : createPostMode,
          appBarTrailingText:
              widget.isEditMode ? titleUpdateButton : titleCreateButton,
          isEditMode: widget.isEditMode,
        );
      },
    );
  }
}

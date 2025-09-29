import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/controller/create_post_controller.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_setting_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/multiple_photo_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/multiple_video_layout.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/bottom_sheet_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/check_is_url.dart';
import 'package:vdiary_internship/presentation/shared/widgets/appbar/appbar_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/link_preview_generator/link_preview_card_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import 'dart:async';

// RELATIVE IMPORT
import '../post_option_draggable.dart';
import '../caption_form_post.dart';
import '../header_form_post.dart';
import 'post_option_layout.dart';

class FormPostLayout extends StatefulWidget {
  final VoidCallback? onTap;
  final TextEditingController contentController;
  final Function(String)? onOptionTap;
  final List<String> imagePaths;
  final List<String> videoPaths;
  final VoidCallback? onAddImage;
  final Function(int)? onRemoveImage;
  final Function(int)? onRemoveVideo;
  final VoidCallback? appBarOnPost;
  final String? appBarTitle;
  final String? appBarTrailingText;
  final bool isEditMode;

  const FormPostLayout({
    super.key,
    this.onTap,
    required this.contentController,
    this.onOptionTap,
    required this.imagePaths,
    required this.videoPaths,
    this.onAddImage,
    this.onRemoveImage,
    this.onRemoveVideo,
    this.appBarOnPost,
    this.appBarTitle,
    this.appBarTrailingText,
    this.isEditMode = false,
  });

  @override
  State<FormPostLayout> createState() => _FormPostLayoutState();
}

class _FormPostLayoutState extends State<FormPostLayout> {
  CreatePostController? createPostController;
  List<String> _urls = [];

  @override
  void initState() {
    super.initState();
    widget.contentController.addListener(_onTextChanged);
    _onTextChanged();
  }

  @override
  void dispose() {
    widget.contentController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Khởi tạo create_post_controller
    createPostController = CreatePostController(
      notificationStore: context.notificationStore,
      tagUserStore: context.tagUserStore,
      networkStatusStore: context.netWorkStore,
      createStore: context.createPostStore,
    );
    super.didChangeDependencies();
  }

  void _onTextChanged() {
    final text = widget.contentController.text;
    final foundUrls = findAllUrls(text);
    if (!listEquals(_urls, foundUrls)) {
      setState(() {
        _urls = foundUrls;
      });
    }
  }

  // Show AI settings bottom sheet
  void _showAISettingsBottomSheet() {
    context.showBottomSheet(
      text: 'AI Settings',
      height: ResponsiveSizeApp(context).screenHeight * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            HSpacing(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.purple.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI-Powered Features',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enhance your content creation with AI-powered tools. Enable features to unlock advanced options.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            HSpacing(20),

            // AI Generate Caption Section
            Observer(
              builder: (_) {
                final store = context.createPostStore;
                return Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('AI Generate Caption'),
                      subtitle: const Text(
                        'Automatically generate caption using AI',
                      ),
                      value: store.isAIGenCaptionEnabled,
                      onChanged: (bool? value) {
                        store.setAIGenCaptionEnabled(value ?? false);
                        // Only close if both main options are off
                        if (!store.isAIGenCaptionEnabled &&
                            !store.isAIGenImageEnabled) {
                          Navigator.pop(context);
                        }
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),

                    // Caption sub-options (only show when main option is enabled)
                    if (store.isAIGenCaptionEnabled)
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              // Writing Style Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Thể loại văn phong',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'Tự nhiên',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Tự nhiên',
                                            child: Text('Tự nhiên'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Chuyên nghiệp',
                                            child: Text('Chuyên nghiệp'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Thân thiện',
                                            child: Text('Thân thiện'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Hài hước',
                                            child: Text('Hài hước'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Trang trọng',
                                            child: Text('Trang trọng'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Sáng tạo',
                                            child: Text('Sáng tạo'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle writing style change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DividerWidget(height: 1),
                              // Text Length Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Độ dài',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'Trung bình',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Ngắn',
                                            child: Text('Ngắn (50-100 từ)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Trung bình',
                                            child: Text(
                                              'Trung bình (100-200 từ)',
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Dài',
                                            child: Text('Dài (200-400 từ)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Rất dài',
                                            child: Text('Rất dài (400+ từ)'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle text length change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (store.isAIGenCaptionEnabled) HSpacing(10),
                  ],
                );
              },
            ),

            const Divider(),

            // AI Generate Image Section
            Observer(
              builder: (_) {
                final store = context.createPostStore;
                return Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('AI Generate Image'),
                      subtitle: const Text('Enhance images using AI'),
                      value: store.isAIGenImageEnabled,
                      onChanged: (bool? value) {
                        store.setAIGenImageEnabled(value ?? false);
                        // Only close if both main options are off
                        if (!store.isAIGenCaptionEnabled &&
                            !store.isAIGenImageEnabled) {
                          Navigator.pop(context);
                        }
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),

                    // Image sub-options (only show when main option is enabled)
                    if (store.isAIGenImageEnabled)
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              // Aspect Ratio Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tỷ lệ khung hình',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'social_story_9_16',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'social_story_9_16',
                                            child: Text('Story 9:16'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'square_1_1',
                                            child: Text('Vuông 1:1'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'landscape_16_9',
                                            child: Text('Ngang 16:9'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'portrait_3_4',
                                            child: Text('Dọc 3:4'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle aspect ratio change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // Style Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phong cách',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'photo',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'photo',
                                            child: Text('Ảnh thật'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'illustration',
                                            child: Text('Minh họa'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'anime',
                                            child: Text('Anime'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'cartoon',
                                            child: Text('Hoạt hình'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'digital_art',
                                            child: Text('Nghệ thuật số'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle style change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // Color Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Màu sắc',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'pastel',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'pastel',
                                            child: Text('Pastel'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'vibrant',
                                            child: Text('Sống động'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'monochrome',
                                            child: Text('Đơn sắc'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'warm',
                                            child: Text('Ấm áp'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'cool',
                                            child: Text('Lạnh lẽ'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'natural',
                                            child: Text('Tự nhiên'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle color change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // Lightning Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ánh sáng',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'warm',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'warm',
                                            child: Text('Ấm áp'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'cool',
                                            child: Text('Lạnh lẽ'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'natural',
                                            child: Text('Tự nhiên'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'dramatic',
                                            child: Text('Kịch tính'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'soft',
                                            child: Text('Mềm mại'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'bright',
                                            child: Text('Sáng'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle lightning change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              // Framing Dropdown
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Góc chụp',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: 'portrait',
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'portrait',
                                            child: Text('Chân dung'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'landscape',
                                            child: Text('Phong cảnh'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'close_up',
                                            child: Text('Cận cảnh'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'wide_shot',
                                            child: Text('Toàn cảnh'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'medium_shot',
                                            child: Text('Cảnh vừa'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          // TODO: Handle framing change
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (store.isAIGenImageEnabled) HSpacing(10),
                  ],
                );
              },
            ),

            HSpacing(20),
          ],
        ),
      ),
    );
  }

  void _confirmBackNavigate() {
    // Nếu đang ở chế độ edit -> đóng luôn (vì edit có thể hủy)
    if (widget.isEditMode == true) {
      if (mounted) {
        context.createPostStore.clearAll();
        context.tagUserStore.clearSelectedUserInfor();
      }
      Navigator.of(context).pop();
      return;
    }

    // Nếu có nội dung (từ store hoặc controller) -> hỏi lưu draft
    final hasText =
        context.createPostStore.caption.trim().isNotEmpty ||
        widget.contentController.text.trim().isNotEmpty;
    final hasMedia = context.createPostStore.canPost;

    if (hasText || hasMedia) {
      context.showCustomDialog(
        height: ResponsiveSizeApp(context).heightPercent(260),
        width: ResponsiveSizeApp(context).screenWidth * 0.75,
        showCloseButton: false,
        barrierDismissible: true,
        title: 'Save this post as a draft?',
        subtitle: 'If you discard now, you\'ll lose this post',
        child: Column(
          children: [
            DividerWidget(height: 1),
            HSpacing(10),
            GestureDetector(
              onTap: () async {
                await context.createPostStore.saveDraft();
                if (!mounted) return;
                AppNavigator.toDashboard(context, tabIndex: 0);
                await Future.delayed(const Duration(milliseconds: 200));
                if (!mounted) return;
                ToastAppWidget.showSuccessToast(
                  context,
                  'Your post has been saved as a draft',
                );
              },
              child: Center(
                child: Text(
                  'Save draft',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightBlue,
                  ),
                ),
              ),
            ),
            HSpacing(10),
            DividerWidget(height: 1),
            HSpacing(10),
            GestureDetector(
              onTap: () {
                context.createPostStore.clearAll();
                context.tagUserStore.clearSelectedUserInfor();
                AppNavigator.toDashboard(context);
              },
              child: Center(
                child: Text(
                  'Discard post',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.errorRed,
                  ),
                ),
              ),
            ),
            HSpacing(10),
            DividerWidget(height: 1),
            HSpacing(10),
            GestureDetector(
              onTap: () => AppNavigator.pop(context),
              child: Center(
                child: Text(
                  'Keep editing',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.lightBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      AppNavigator.canPop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomAppBarWidget(
          title: widget.appBarTitle ?? 'Create Post',
          trailingText: widget.appBarTrailingText ?? 'Post',
          currentPage: 'form-create-post',
          onLeadingPressed: _confirmBackNavigate,
          onTrailingPressed: widget.appBarOnPost,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PaddingLayout.symmetric(
              horizontal: ResponsiveSizeApp(
                context,
              ).moderateScale(PaddingSizeApp.paddingSizeSubMedium),
              child: SingleChildScrollView(
                child: Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        // HEADER CỦA FORM
                        HeaderInputWidget(),

                        // TAGGED USERS DISPLAY
                        SettingPostLayout(
                          children: [
                            PostSettingSectionWidget(
                              () => widget.onTap!(),
                              text: context.audienceStore.typeAudience,
                              iconImage: context.audienceStore.typeAudienceIcon,
                            ),

                            WSpacing(5),

                            PostSettingSectionWidget(
                              () {},
                              text: 'Album',
                              iconImage: ImagePath.plusImageIcon,
                            ),
                          ],
                        ),

                        HSpacing(8),

                        SettingPostLayout(
                          children: [
                            PostSettingSectionWidget(
                              () {},
                              text: 'Off',
                              iconImage: ImagePath.instaImageIcon,
                            ),
                            WSpacing(5),
                            PostSettingSectionWidget(
                              _showAISettingsBottomSheet,
                              text: context.createPostStore.aiStatusText,
                              iconImage: ImagePath.colorAIIcon,
                            ),
                          ],
                        ),

                        HSpacing(8),

                        SettingPostLayout(
                          children: [
                            PostSettingSectionWidget(
                              () => createPostController
                                  ?.showMicSettingsBottomSheet(context),
                              text: context.createPostStore.micStatusText,
                              iconImage: ImagePath.micIcon,
                            ),
                          ],
                        ),

                        HSpacing(20),

                        // FORM INPUT CONTENT
                        SizedBox(
                          child: ContentPostInputWidget(
                            controller: widget.contentController,
                          ),
                        ),

                        // PREVIEW LINK URL
                        if (_urls.isNotEmpty)
                          Column(
                            children:
                                _urls
                                    .map(
                                      (url) => LinkPreviewCardWidget(url: url),
                                    )
                                    .toList(),
                          ),

                        // LAYOUT IMAGE
                        _buildImageLayout(context),

                        // LAYOUT VIDEO
                        if (widget.videoPaths.isNotEmpty)
                          Observer(
                            builder: (_) {
                              final createPostStore = context.createPostStore;
                              final isPostQueued =
                                  createPostStore.postNeedWifi.isNotEmpty &&
                                  widget.videoPaths.isNotEmpty;

                              Widget videoLayout = MultipleVideoLayout(
                                videoPaths: widget.videoPaths,
                                onRemoveVideo: widget.onRemoveVideo!,
                              );

                              // Add overlay if post is queued for WiFi
                              if (isPostQueued) {
                                videoLayout = Stack(
                                  children: [
                                    videoLayout,
                                    Container(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.wifi_off,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Waiting for WiFi',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Post will be published when WiFi is available',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return videoLayout;
                            },
                          ),
                        HSpacing(30),

                        // BUTTON CHOOSE LAYOUT
                        context.createPostStore.selectedImagePaths.isNotEmpty
                            ? _buildButtonChooseLayout(context)
                            : Container(),

                        HSpacing(120),
                      ],
                    );
                  },
                ),
              ),
            ),

            // DRAGGABLE OPTION POST
            Align(
              alignment: Alignment.bottomCenter,
              child: FormOptionDraggable(onOptionTap: widget.onOptionTap),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImageLayout(BuildContext context) {
  return Observer(
    builder: (_) {
      final createPostStore = context.createPostStore;
      final isPostQueued =
          createPostStore.postNeedWifi.isNotEmpty &&
          createPostStore.selectedImagePaths.isNotEmpty;

      Widget imageLayout = Container(
        width: ResponsiveSizeApp(context).screenWidth,
        decoration: BoxDecoration(color: Colors.transparent),
        child: MultiplePhotoLayout(
          imageUrls: context.createPostStore.selectedImagePaths,
          createPostContext: context,
          mode: TypeMode.edit.name,
        ),
      );

      // Add overlay if post is queued for WiFi
      if (isPostQueued) {
        imageLayout = Stack(
          children: [
            imageLayout,
            Container(
              color: Colors.grey.withValues(alpha: 0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 48, color: Colors.white),
                    Text(
                      'Waiting for WiFi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Post will be published when WiFi is available',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      return imageLayout;
    },
  );
}

Widget _buildButtonChooseLayout(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Column(
        children: [
          Container(
            width: ResponsiveSizeApp(context).widthPercent(50),
            height: ResponsiveSizeApp(context).heightPercent(50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.lightGrey,
            ),
            child: Center(
              child: PaddingLayout.all(
                value: 5,
                child: Icon(
                  FluentIcons.layout_cell_four_24_filled,
                  color: AppColor.mediumGrey,
                  size: IconSizeApp.iconSizeLarge,
                ),
              ),
            ),
          ),
          HSpacing(8),
          Text(
            'Choose Layout',
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_section_widget.dart';
import 'package:vdiary_internship/presentation/pages/profile/controller/profile_controller.dart';
import 'package:vdiary_internship/presentation/pages/profile/store/profile_post_store.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import '../../../../core/constants/size/size_app.dart';
import '../../../shared/widgets/sticky_header/sticky_header_widget.dart';
import '../../../themes/theme/app-color/app_color.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final ProfileController _profileController;
  late final ProfilePostStore _profilePostStore;
  int selectedTabIndex = 0;
  String? imagePath;
  String? backgroundPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileController = ProfileController(
      context.authStore,
      context.profilePostStore,
    );
    _profilePostStore = context.profilePostStore;

    // Clear all posts first to avoid showing cached posts from other users
    _profilePostStore.clearAllPosts();

    // Then load user's own posts
    _profilePostStore.loadOwnPosts();
  }

  // Hàm chọn ảnh
  void pickImage(bool isCamera, BuildContext context, String type) async {
    final newImagePath = await _profileController.pickAndCropImage(
      fromCamera: isCamera,
    );
    if (newImagePath == null || newImagePath.isEmpty) return;

    setState(() {
      if (type == 'avatar') {
        imagePath = newImagePath;
      } else if (type == 'background') {
        backgroundPath = newImagePath;
      }
    });

    if (context.mounted) {
      await _profileController.uploadAvatar(newImagePath, context, type);
    }
  }

  // Hàm tính kích thước của collapse sliver appbar
  double _collapsePercent(BoxConstraints constraints) {
    return ((constraints.maxHeight - kToolbarHeight) /
            (expandHeight + 75 - kToolbarHeight))
        .clamp(0.0, 1.0);
  }

  void _handleChooseOptionAvatar(BuildContext context, String type) {
    context.showCustomDialog(
      showCloseButton: false,
      barrierDismissible: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _listTileChoose(
            ImagePath.cameraDefaultIcon,
            'Use camera',
            context,
            () => pickImage(true, context, type),
          ),
          HSpacing(20),
          _listTileChoose(
            ImagePath.galleryIcon,
            'Use picture from gallery',
            context,
            () => pickImage(false, context, type),
          ),
        ],
      ),
    );
  }

  Widget _listTileChoose(
    String imagePath,
    String text,
    BuildContext context,
    VoidCallback func,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close the dialog first
        func(); // Then execute the function
      },
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveSizeApp(context).widthPercent(20),
            height: ResponsiveSizeApp(context).heightPercent(20),
            child: SvgPicture.asset(imagePath),
          ),
          WSpacing(10),
          Text(text, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildAvatar(double size, String userAvatarUrl) {
    final avatarUrl =
        (userAvatarUrl.isNotEmpty)
            ? '$userAvatarUrl?v=${DateTime.now().millisecondsSinceEpoch}'
            : ImagePath.avatarDefault;
    return InkWell(
      onTap: () {
        _handleChooseOptionAvatar(context, TypeUpload.avatar.name);
      },
      child: AvatarBoxShadowWidget(
        width: size,
        height: size,
        horizontalVector: 4,
        verticalVector: 0,
        radiusContainer: 100,
        radiusImage: 100,
        imageUrl: avatarUrl,
      ),
    );
  }

  final double expandHeight = 200;
  List<String> items = List.generate(30, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final authStore = context.authStore;
        final user = authStore.userInfo ?? <String, dynamic>{};
        final coverUrl = user['background'];
        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: RefreshIndicator(
            onRefresh: () async {
              await _profilePostStore.loadOwnPosts();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: expandHeight + 75,
                  pinned: true,
                  centerTitle: true,
                  backgroundColor: AppColor.backgroundColor,
                  foregroundColor: AppColor.backgroundColor,
                  leading: Container(
                    margin: EdgeInsets.all(PaddingSizeApp.paddingSizeSubMedium),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed:
                          () => AppNavigator.toDashboard(context, tabIndex: 4),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: IconSizeApp.iconSizeSmall,
                        color: AppColor.backgroundColor,
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: PaddingSizeApp.paddingSizeSubMedium,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FluentIcons.edit_12_regular,
                          size: IconSizeApp.iconSizeSmall,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: PaddingSizeApp.paddingSizeSubMedium,
                        horizontal: PaddingSizeApp.paddingSizeSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FluentIcons.search_sparkle_32_filled,
                          size: IconSizeApp.iconSizeSmall,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  title: null, // Title handled in flexibleSpace
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final percent = _collapsePercent(constraints);
                      final avatarSize = 120 * percent + 40 * (1 - percent);
                      return Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          if (percent > 0.4) ...[
                            MyImageWidget(imageUrl: coverUrl),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 40,
                              child: Center(
                                child: _buildAvatar(
                                  avatarSize,
                                  user['avatar'] ?? '',
                                ),
                              ),
                            ),
                          ],
                          if (percent <= 0.4)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${user['name']}',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          if (percent > 0.4)
                            Positioned(
                              right: 10,
                              bottom: 20,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    _handleChooseOptionAvatar(
                                      context,
                                      TypeUpload.background.name,
                                    );
                                  },
                                  child: Opacity(
                                    opacity: percent,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            color: Colors.black,
                                            size: IconSizeApp.iconSizeSmall,
                                          ),
                                          WSpacing(4),
                                          Text(
                                            'Add Cover Photo',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  FontSizeApp.fontSizeSmall,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                // Sticky Header với tabs
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickySectionHeaderDelegate(
                    child: Container(
                      color: AppColor.backgroundColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          _buildTabButton(0, 'Posts'),
                          WSpacing(20),
                          _buildTabButton(1, 'Photos'),
                          WSpacing(20),
                          _buildTabButton(2, 'Videos'),
                        ],
                      ),
                    ),
                  ),
                ),
                // User Info Section
                SliverToBoxAdapter(child: _buildUserInfoSection(user)),
                // Content based on selected tab
                _buildTabContent(user),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build User Info Section
  Widget _buildUserInfoSection(Map<String, dynamic> user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Name & Verified
          Row(
            children: [
              Text(
                user['name'] ?? 'Unknown User',
                style: TextStyle(
                  fontSize: FontSizeApp.fontSubTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (user['verified'])
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.verified, color: Colors.blue, size: 20),
                ),
              if (user['role'] == UserRole.user.name)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.shield, color: Colors.red, size: 18),
                ),
            ],
          ),
          HSpacing(5),

          // Friends Count
          Observer(
            builder: (_) {
              final friendStore = context.friendStore;
              return RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: FontSizeApp.fontSizeSmall),
                  children: [
                    TextSpan(
                      text: '${friendStore.friends.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' friends',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          HSpacing(5),

          // Ngày tham gia
          if (user['createdAt'] != null)
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Joined: ${formatDate(user['createdAt'])}',
                  style: TextStyle(
                    fontSize: FontSizeApp.fontSizeSmall,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          HSpacing(8),

          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Add to story',
                  Icons.add,
                  AppColor.lightBlue,
                  Colors.white,
                  () => {},
                  true,
                ),
              ),
              WSpacing(10),
              Expanded(
                child: _buildActionButton(
                  'Edit profile',
                  Icons.edit,
                  AppColor.lightGrey,
                  Colors.black,
                  () => AppNavigator.toEditProfielScreen(context),
                  false,
                ),
              ),
              WSpacing(10),
              _buildMoreButton(),
            ],
          ),

          HSpacing(10),

          // Email
          Observer(
            builder: (_) {
              final friendStore = context.friendStore;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    ImagePath.instagramIcon,
                    width: 20,
                    height: 20,
                  ),
                  WSpacing(4),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.defaultColor,
                      ),
                      children: [
                        TextSpan(text: '_ptrhungg_ '),
                        TextSpan(
                          text:
                              '${friendStore.followers.length} followers (+1 link)',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          HSpacing(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(ImagePath.hatIcon, width: 20, height: 20),
              WSpacing(4),
              Text(
                'Went to Trường THPT Hoàng Hoa Thám',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          HSpacing(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(ImagePath.homeIcon, width: 20, height: 20),
              WSpacing(4),
              RichText(
                text: TextSpan(
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColor.defaultColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Lives in',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: ' Da Nang, Viet Nam',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build Tab Button với state management
  Widget _buildTabButton(int index, String text) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.superLightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.superLightBlue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: FontSizeApp.fontSizeSubMedium,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColor.lightBlue : Colors.black,
          ),
        ),
      ),
    );
  }

  // Build Tab Content
  Widget _buildTabContent(Map<String, dynamic> user) {
    switch (selectedTabIndex) {
      case 0:
        return _buildPostsContent(user);
      case 1:
        return _buildPhotosContent();
      case 2:
        return _buildVideosContent();
      default:
        return _buildPostsContent(user);
    }
  }

  // Build Posts Content
  Widget _buildPostsContent(Map<String, dynamic> user) {
    return Observer(
      builder: (_) {
        debugPrint('🔍 Profile Posts Debug:');
        debugPrint('📊 isLoading: ${_profilePostStore.isLoading}');
        debugPrint('📝 ownPosts count: ${_profilePostStore.ownPosts.length}');
        debugPrint('❌ errorMessage: ${_profilePostStore.errorMessage}');

        if (_profilePostStore.isLoading && _profilePostStore.ownPosts.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (_profilePostStore.errorMessage != null) {
          return SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Error: ${_profilePostStore.errorMessage!}',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _profilePostStore.loadOwnPosts(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (_profilePostStore.ownPosts.isEmpty &&
            !_profilePostStore.isLoading) {
          return SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.post_add, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No posts yet', style: context.textTheme.bodyLarge),
                    SizedBox(height: 8),
                    Text(
                      'Create your first post to share with friends!',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final post = _profilePostStore.ownPosts[index];
            return PostSectionWidget(
              key: ValueKey('profile_post_${post.id}_$index'),
              post: post,
            );
          }, childCount: _profilePostStore.ownPosts.length),
        );
      },
    );
  }

  // Build Photos Content
  Widget _buildPhotosContent() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(color: AppColor.lightGrey),
          child: Center(
            child: Text(
              'Photo $index',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }, childCount: 20),
    );
  }

  // Build Videos Content
  Widget _buildVideosContent() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill, color: Colors.white, size: 60),
                SizedBox(height: 8),
                Text(
                  'Video $index',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: 5),
    );
  }

  // Build Action Button
  Widget _buildActionButton(
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
    VoidCallback actionFunction,
    bool isAdd,
  ) {
    return GestureDetector(
      onTap: actionFunction,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: IconSizeApp.iconSizeSmall),
            WSpacing(10),
            Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isAdd ? AppColor.backgroundColor : AppColor.defaultColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build More Button
  Widget _buildMoreButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColor.lightGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
    );
  }
}

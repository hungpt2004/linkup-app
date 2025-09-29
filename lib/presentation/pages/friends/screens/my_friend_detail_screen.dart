import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/friends/controller/friends_controller.dart';
import 'package:vdiary_internship/presentation/pages/profile/controller/profile_controller.dart';
import 'package:vdiary_internship/presentation/pages/profile/store/profile_post_store.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_header_widget.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_caption_widget.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_stats_widget.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_actions_widget.dart';
import 'package:vdiary_internship/presentation/shared/utils/check_is_url.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import '../../../../core/constants/size/size_app.dart';
import '../../../shared/widgets/sticky_header/sticky_header_widget.dart';
import '../../../themes/theme/app-color/app_color.dart';

class MyFriendDetailScreen extends StatefulWidget {
  const MyFriendDetailScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<MyFriendDetailScreen> createState() => _MyFriendDetailScreenState();
}

class _MyFriendDetailScreenState extends State<MyFriendDetailScreen> {
  int selectedTabIndex = 0;
  late final ProfileController _profileController;
  late final ProfilePostStore _profilePostStore;
  late final FriendController _friendController;
  bool _isInitialized = false;

  // Helper to calculate percent collapse
  double _collapsePercent(BoxConstraints constraints) {
    return ((constraints.maxHeight - kToolbarHeight) /
            (expandHeight + 75 - kToolbarHeight))
        .clamp(0.0, 1.0);
  }

  // Helper to build avatar
  Widget _buildAvatar(double size) {
    final user = widget.user;
    final avatarUrl =
        (user.avatarUrl?.isNotEmpty ?? false)
            ? user.avatarUrl!
            : ImagePath.avatarDefault;
    return Hero(
      tag: 'friend_detail_avatar_${user.id}',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColor.backgroundColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: MyImageWidget(imageUrl: avatarUrl),
        ),
      ),
    );
  }

  final double expandHeight = 200;
  List<String> items = List.generate(30, (index) => 'Item $index');

  // Refresh function
  Future<void> _onRefresh() async {
    if (!_isInitialized) {
      debugPrint('❌ Controllers not initialized yet');
      return;
    }

    try {
      final userId = widget.user.id;
      if (userId != null && userId.isNotEmpty) {
        debugPrint('🔄 Refreshing posts for user: $userId');
        _profilePostStore.clearAllPosts();
        await _profileController.findPostByUserId(userId: userId);
      } else {
        debugPrint('❌ Invalid userId for refresh: $userId');
      }
    } catch (e) {
      debugPrint('❌ Error during refresh: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Khởi tạo controllers chỉ một lần
    if (!_isInitialized) {
      try {
        _profileController = ProfileController(
          context.authStore,
          context.profilePostStore,
        );
        _profilePostStore = context.profilePostStore;
        _friendController = FriendController(
          context.friendStore,
          context.userStore,
        );

        // Kiểm tra userId trước khi load
        final userId = widget.user.id;
        if (userId != null && userId.isNotEmpty) {
          debugPrint('🔄 Loading posts for user: $userId');
          _profilePostStore.clearAllPosts();
          _profileController.findPostByUserId(userId: userId);
        } else {
          debugPrint('❌ Invalid userId: $userId');
        }
        _isInitialized = true;
      } catch (e) {
        debugPrint('❌ Error initializing controllers: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khai báo store và controller
    final user = widget.user;

    final coverUrl =
        (user.coverImageUrl?.isNotEmpty ?? false)
            ? user.coverImageUrl!
            : ImagePath.backgroundDefault;
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: expandHeight + 75,
              pinned: true,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.edit_12_regular,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.search_sparkle_32_filled,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final percent = _collapsePercent(constraints);
                  final avatarSize = 120 * percent + 40 * (1 - percent);
                  final avatarBottom = 24 * percent;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (percent > 0.4) MyImageWidget(imageUrl: coverUrl),
                      if (percent <= 0.4)
                        Container(color: AppColor.backgroundColor),
                      Positioned(
                        left:
                            ResponsiveSizeApp(context).screenWidth / 2 -
                            avatarSize / 2,
                        bottom: avatarBottom,
                        child: _buildAvatar(avatarSize),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            SliverToBoxAdapter(child: _buildUserInfoSection(_friendController)),
            // Content based on selected tab
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  // Build User Info Section
  Widget _buildUserInfoSection(FriendController friendController) {
    final user = widget.user;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Name & Verified
          Row(
            children: [
              Text(
                user.name ?? 'Unknown User',
                style: TextStyle(
                  fontSize: FontSizeApp.fontSubTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (user.verified)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.verified, color: Colors.blue, size: 20),
                ),
              if (user.role == UserRole.admin)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.shield, color: Colors.red, size: 18),
                ),
            ],
          ),

          HSpacing(5),

          // Email
          if (user.email != null)
            Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: FontSizeApp.fontSizeSmall,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

          HSpacing(5),

          // Details
          _buildInforDetail(),

          // Friends Count
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: FontSizeApp.fontSizeSmall),
              children: [
                TextSpan(
                  text: '${user.numberFriends}',
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
          ),

          HSpacing(5),

          // Ngày tham gia
          if (user.createdAt != null)
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Joined: ${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}',
                  style: TextStyle(
                    fontSize: FontSizeApp.fontSizeSmall,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

          HSpacing(20),

          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                  future: friendController.checkIsFriend(user.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: ResponsiveSizeApp(context).heightPercent(36),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData && snapshot.data == true) {
                      return _buildActionButton(
                        'Friend',
                        FluentIcons.people_chat_24_filled,
                        AppColor.lightGrey,
                        AppColor.defaultColor,
                      );
                    } else {
                      return _buildActionButton(
                        'Add Friend',
                        Icons.add,
                        AppColor.lightBlue,
                        Colors.white,
                      );
                    }
                  },
                ),
              ),
              WSpacing(10),
              Expanded(
                child: _buildActionButton(
                  'Message',
                  FluentIcons.chat_48_filled,
                  AppColor.lightBlue,
                  AppColor.backgroundColor,
                ),
              ),
              WSpacing(10),
              _buildMoreButton(),
            ],
          ),

          HSpacing(10),
        ],
      ),
    );
  }

  Widget _buildInforDetail() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Details'),
          _buildTitleDetail(
            imagePath: ImagePath.instagramIcon,
            text: 'instagram_account',
          ),
          _buildTitleDetail(
            imagePath: ImagePath.hatIcon,
            text: 'Went to Trường THPT Thái Phiên Đà Nẵng',
          ),
          _buildTitleDetail(
            imagePath: ImagePath.hatIcon,
            text: 'Studies at FPT University Da Nang',
          ),
          _buildTitleDetail(
            imagePath: ImagePath.homeIcon,
            text: 'Lives in Da Nang, Vietnam',
          ),
        ],
      ),
    );
  }

  Widget _buildTitleDetail({required String imagePath, required String text}) {
    return Row(
      children: [
        SizedBox(
          width: ResponsiveSizeApp(context).widthPercent(15),
          height: ResponsiveSizeApp(context).heightPercent(15),
          child: ClipRRect(
            child: SvgPicture.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        WSpacing(5),
        Text(
          text,
          style: TextStyle(
            fontSize: FontSizeApp.fontSizeSmall,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildPostsContent();
      case 1:
        return _buildPhotosContent();
      case 2:
        return _buildVideosContent();
      default:
        return _buildPostsContent();
    }
  }

  // Build Posts Content
  Widget _buildPostsContent() {
    if (!_isInitialized) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Observer(
      key: ValueKey('friend_posts_observer_${widget.user.id}'),
      builder: (context) {
        if (_profilePostStore.isLoading &&
            _profilePostStore.userPosts.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (_profilePostStore.isUserPostsEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.post_add, size: 50, color: AppColor.mediumGrey),
                    SizedBox(height: 16),
                    Text(
                      'No posts yet',
                      style: TextStyle(
                        fontSize: FontSizeApp.fontSizeMedium,
                        color: AppColor.mediumGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This user hasn\'t shared any posts.',
                      style: TextStyle(
                        fontSize: FontSizeApp.fontSizeSmall,
                        color: AppColor.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final posts = _profilePostStore.currentPosts;
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final post = posts[index];
            final foundUrls = findAllUrls(post.caption);

            return Container(
              key: ValueKey(
                'friend_post_${post.id}_$index',
              ), // Unique key cho mỗi post
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Avatar, Name, Time, Privacy giống HomeScreen
                  PostHeaderSectionWidget(
                    key: ValueKey('header_${post.id}'),
                    post: post,
                  ),

                  // Content & Caption với hashtags, mentions giống HomeScreen
                  PostCaptionSectionWidget(
                    key: ValueKey('caption_${post.id}'),
                    urls: foundUrls,
                    post: post,
                  ),

                  HSpacing(10),

                  // Like, Comment count với reactions giống HomeScreen
                  PostStatsWidget(
                    key: ValueKey('stats_${post.id}'),
                    post: post,
                  ),

                  HSpacing(15),

                  // Action buttons với reaction picker giống HomeScreen
                  PostActionsWidget(
                    key: ValueKey('actions_${post.id}'),
                    postId: post.id,
                    post: post,
                  ),

                  HSpacing(10),

                  // Divider
                  DividerWidget(height: 4),
                ],
              ),
            );
          }, childCount: posts.length),
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
  ) {
    return Container(
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
            style: TextStyle(
              color: textColor,
              fontSize: FontSizeApp.fontSizeSubMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

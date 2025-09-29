import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/profile/controller/profile_controller.dart';
import 'package:vdiary_internship/presentation/pages/profile/store/profile_post_store.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart'; // Import padding constants

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key, this.user, this.userId});

  final UserModel? user;
  final String? userId;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late final ProfileController profileController;
  late final ProfilePostStore _profilePostStore;
  UserModel? _user;
  int selectedTabIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileController = ProfileController(
      context.authStore,
      context.profilePostStore,
    );
    _profilePostStore = context.profilePostStore;

    // Clear all posts first to avoid showing cached posts
    _profilePostStore.clearAllPosts();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Set user data if provided
      if (widget.user != null) {
        _user = widget.user;
      }

      // Load user posts
      if (widget.userId != null) {
        debugPrint(
          '🎯 ProfileDetailScreen: Loading posts for userId: ${widget.userId}',
        );
        await _profilePostStore.loadUserPosts(userId: widget.userId!);
        debugPrint(
          '📊 Posts loaded count: ${_profilePostStore.userPosts.length}',
        );
      } else {
        debugPrint('❌ ProfileDetailScreen: userId is null!');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.userId != null) {
            await _profilePostStore.loadUserPosts(userId: widget.userId!);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                _user!.name ?? 'User Profile',
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(background: _buildCoverImage()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildProfileDetails(),
                  _buildActionButtons(),
                  _buildTabBar(),
                ],
              ),
            ),
            // Content based on selected tab
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final coverUrl = _user!.coverImageUrl ?? ImagePath.backgroundDefault;
    return Image.network(
      coverUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.image, color: Colors.white, size: 50),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(PaddingSizeApp.paddingSizeMedium),
      margin: const EdgeInsets.only(bottom: PaddingSizeApp.paddingSizeMedium),
      child: Row(
        children: [
          _buildAvatar(),
          const WSpacing(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user!.name ?? 'Unknown User',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const HSpacing(8),
                Text(
                  _user!.email ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const HSpacing(8),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const WSpacing(4),
                    Text(
                      '${_user!.numberFriends} friends',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = _user!.avatarUrl ?? ImagePath.avatarDefault;
    return AvatarBoxShadowWidget(
      width: 80,
      height: 80,
      horizontalVector: 4,
      verticalVector: 0,
      radiusContainer: 100,
      radiusImage: 100,
      imageUrl: avatarUrl,
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PaddingSizeApp.paddingSizeMedium),
      margin: const EdgeInsets.symmetric(
        horizontal: PaddingSizeApp.paddingSizeMedium,
        vertical: PaddingSizeApp.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const HSpacing(12),
          Text(
            'Member since ${_formatDate(_user!.createdAt)}',
            style: context.textTheme.bodyMedium,
          ),
          const HSpacing(8),
          if (_user!.verified)
            Row(
              children: [
                Icon(
                  Icons.verified,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const WSpacing(4),
                Text(
                  'Verified Account',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(PaddingSizeApp.paddingSizeMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Add friend functionality
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizeApp.paddingSizeLarge,
                vertical: PaddingSizeApp.paddingSizeMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Add Friend'),
          ),
          OutlinedButton(
            onPressed: () {
              // Send message functionality
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizeApp.paddingSizeLarge,
                vertical: PaddingSizeApp.paddingSizeMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Message'),
          ),
        ],
      ),
    );
  }

  // Build Tab Bar
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildTabButton(0, 'Posts'),
          const WSpacing(16),
          _buildTabButton(1, 'Photos'),
          const WSpacing(16),
          _buildTabButton(2, 'Videos'),
        ],
      ),
    );
  }

  // Build Tab Button
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
            fontSize: 14,
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

  // Build Posts Content with Observer
  Widget _buildPostsContent() {
    return Observer(
      builder: (_) {
        debugPrint('🔍 Profile Detail Posts Debug:');
        debugPrint('📊 isLoading: ${_profilePostStore.isLoading}');
        debugPrint('📝 userPosts count: ${_profilePostStore.userPosts.length}');
        debugPrint('❌ errorMessage: ${_profilePostStore.errorMessage}');
        debugPrint('👤 userId: ${widget.userId}');

        if (_profilePostStore.isLoading &&
            _profilePostStore.userPosts.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (_profilePostStore.errorMessage != null) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Error: ${_profilePostStore.errorMessage!}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.userId != null) {
                          _profilePostStore.loadUserPosts(
                            userId: widget.userId!,
                          );
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (_profilePostStore.userPosts.isEmpty &&
            !_profilePostStore.isLoading) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.post_add, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No posts yet', style: context.textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                      'This user hasn\'t shared any posts yet.',
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

        debugPrint(
          '✅ Rendering ${_profilePostStore.userPosts.length} user posts',
        );
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final post = _profilePostStore.userPosts[index];
            debugPrint('📄 Rendering user post: ${post.id} - ${post.caption}');
            return PostSectionWidget(
              key: ValueKey('user_post_${post.id}_$index'),
              post: post,
            );
          }, childCount: _profilePostStore.userPosts.length),
        );
      },
    );
  }

  // Build Photos Content
  Widget _buildPhotosContent() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: AppColor.lightGrey),
          child: Center(
            child: Text(
              'Photo $index',
              style: const TextStyle(
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  'Video $index',
                  style: const TextStyle(
                    color: Colors.white,
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
}

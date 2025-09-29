import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/posts/controllers/post_controller.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../../../themes/theme/app-color/app_color.dart';
import '../widgets/header_home_widget.dart';
import '../../posts/widgets/post_list_widget.dart';
import '../../story/widgets/story_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late PostController _postController;
  bool _isLoadingMore = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   StoreFactory.postStore.initialize();
    // });
  }

  @override
  void didChangeDependencies() {
    _postController = PostController(postStoreRef: context.postStore);

    // Chỉ load posts một lần khi lần đầu vào
    final postStore = context.postStore;
    if (!_hasInitialized &&
        !postStore.isLoading &&
        postStore.posts.isEmpty &&
        !postStore.isLoadedFromCache &&
        !postStore.hasError) {
      _hasInitialized = true;
      // Delay một chút để tránh rebuild liên tục
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.netWorkStore.isWifi) {
          postStore.initialize();
        } else if (mounted) {
          postStore.loadPostsFromHive();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _contentController.dispose();
    // context.postStore.dispose();

    super.dispose();
  }

  void _showFormPost() => AppNavigator.toFormUpPost(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Observer(
        builder: (_) {
          final authStore = context.authStore;
          final postStore = context.postStore;
          final userInfo = authStore.userInfo!;
          return RefreshIndicator(
            displacement: 35,
            onRefresh: postStore.refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                // Check if we're at the end of the scroll
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 300) {
                  // If we're viewing cached posts only and have WiFi, load from API
                  if (postStore.isLoadedFromCache &&
                      !postStore.isLoading &&
                      context.netWorkStore.isWifi) {
                    // Only load from API if we have WiFi connection
                    postStore.loadPosts(refresh: true);
                    return false;
                  }

                  // If we're not loading more and there are more posts, load more
                  if (!_isLoadingMore &&
                      postStore.hasMorePosts &&
                      !postStore.isLoading &&
                      context.netWorkStore.isWifi) {
                    _isLoadingMore = true;
                    postStore.loadMorePosts().then((_) {
                      if (mounted) _isLoadingMore = false;
                    });
                  }
                }
                return false;
              },
              child: CustomScrollView(
                cacheExtent: 1200, // tăng cache cho mượt hơn
                slivers: [
                  const SliverToBoxAdapter(child: HSpacing(kToolbarHeight)),

                  // Header form post
                  SliverToBoxAdapter(
                    child: HeaderFormWidget(onTap: _showFormPost),
                  ),

                  const SliverToBoxAdapter(child: DividerWidget(height: 4)),

                  // Stories section
                  SliverToBoxAdapter(child: StoriesSection(userInfo: userInfo)),

                  const SliverToBoxAdapter(child: DividerWidget(height: 4)),

                  // Filter section
                  SliverToBoxAdapter(child: _buildPreviewVideoOption()),

                  // Posts
                  const PostListWidget(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingButton(context),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: null, // PopupMenuButton sẽ handle
      child: PopupMenuButton<String>(
        color: AppColor.superLightGrey,
        popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 10,
        child: Lottie.asset(
          ImagePath.lottieBoxChat,
          repeat: false, // Giảm lag (không lặp vô hạn)
        ),
        onSelected: (String result) {
          if (result == 'chat_group') {
            AppNavigator.toChatGroupScreen(context);
          } else if (result == 'chat_box') {
            AppNavigator.toChatBoxScreen(context);
          } else if (result == 'chat_support') {
            // hỗ trợ
          }
        },
        itemBuilder: (BuildContext context) {
          return MockData.listOptionsChat.map((item) {
            return _buildPopMenuItem(
              context,
              item['value'],
              item['icon'],
              item['title'],
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildPreviewVideoOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizeApp.paddingSizeMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Lastest Post Newfeeds',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _postController.openFilterHomeBottomSheet(context),
            icon: SvgPicture.asset(ImagePath.filterIcon, width: 24, height: 24),
            tooltip: 'Lọc bài viết',
          ),
        ],
      ),
    );
  }
}

PopupMenuItem<String> _buildPopMenuItem(
  BuildContext context,
  String value,
  String imageIcon,
  String text,
) {
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        SizedBox(width: 20, height: 20, child: SvgPicture.asset(imageIcon)),
        const WSpacing(10),
        Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

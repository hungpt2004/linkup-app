import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/tab/share_action_model.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post-share/optimized_user_selection_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart'
    show HSpacing, WSpacing;

class EnhancedShareBottomSheet extends StatefulWidget {
  final PostModel post;
  final List<ShareActionModel> shareActionLists;
  final List<UserEntity> availableUsers;

  const EnhancedShareBottomSheet({
    super.key,
    required this.post,
    required this.shareActionLists,
    required this.availableUsers,
  });

  @override
  State<EnhancedShareBottomSheet> createState() =>
      _EnhancedShareBottomSheetState();
}

class _EnhancedShareBottomSheetState extends State<EnhancedShareBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();

    // Clear previous selection when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.postStore.clearShareUserLists();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(child: _buildTabBarView(scrollController)),
              _buildBottomActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: AppColor.mediumGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Post',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColor.mediumGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.superLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColor.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColor.mediumGrey,
        labelStyle: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.mediumGrey,
        ),
        unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.mediumGrey,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        automaticIndicatorColorAdjustment: true,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 18),
                WSpacing(8),
                Text('Send to Friends'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 18),
                WSpacing(8),
                Text('Share Options'),
              ],
            ),
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _buildTabBarView(ScrollController scrollController) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
      children: [
        // Friends selection tab
        Padding(
          padding: EdgeInsets.all(20),
          child: Observer(
            builder: (_) {
              final postStore = context.postStore;
              return OptimizedUserSelectionWidget(
                users: widget.availableUsers,
                onUserToggle: (user) {
                  postStore.toggleUserSelection(user);
                },
                onSearchChanged: (query) {
                  postStore.setShareSearchQuery(query);
                },
                searchQuery: context.postStore.shareSearchQuery,
                selectedUsersMap: context.postStore.selectedUsersMap,
              );
            },
          ),
        ),
        // Share options tab
        _buildShareOptionsTab(),
      ],
    );
  }

  Widget _buildShareOptionsTab() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share via other apps',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          HSpacing(16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.shareActionLists.length,
              itemBuilder: (context, index) {
                final action = widget.shareActionLists[index];
                return _ShareActionTile(
                  action: action,
                  iconPath: action.icon,
                  onTap: action.function!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Observer(
      builder: (_) {
        final selectedCount = context.postStore.selectedUsersCount;
        final hasSelection = selectedCount > 0;

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColor.superLightGrey, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (hasSelection) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.successGreen, width: 1),
                  ),
                  child: Text(
                    '$selectedCount selected',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColor.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                WSpacing(12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: hasSelection ? _handleSendToFriends : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasSelection
                            ? AppColor.lightBlue
                            : AppColor.superLightGrey,
                    foregroundColor:
                        hasSelection ? Colors.white : AppColor.mediumGrey,
                    animationDuration: Duration(milliseconds: 300),
                    elevation: hasSelection ? 2 : 0,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    hasSelection
                        ? 'Send to $selectedCount friend${selectedCount > 1 ? 's' : ''}'
                        : 'Select friends to send',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSendToFriends() {
    final selectedUsers = context.postStore.shareUserLists;

    // TODO: Goị api cua send message firebase

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post shared with ${selectedUsers.length} friend${selectedUsers.length > 1 ? 's' : ''}!',
        ),
        backgroundColor: AppColor.successGreen,
      ),
    );

    // Close the bottom sheet
    Navigator.pop(context);

    // Clear selection
    context.postStore.clearShareUserLists();
  }
}

class _ShareActionTile extends StatelessWidget {
  final ShareActionModel action;
  final VoidCallback onTap;
  final String iconPath;

  const _ShareActionTile({
    required this.action,
    required this.onTap,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.superLightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.superLightGrey,
                shape: BoxShape.circle,
              ),
              child: PaddingLayout.all(
                value: 10,
                child: SvgPicture.asset(iconPath, width: 20, height: 20),
              ),
            ),
            HSpacing(8),
            Text(
              action.title,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

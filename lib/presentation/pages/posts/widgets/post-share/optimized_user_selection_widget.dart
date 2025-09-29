import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class OptimizedUserSelectionWidget extends StatefulWidget {
  final List<UserEntity> users;
  final Function(UserEntity) onUserToggle;
  final Function(String) onSearchChanged;
  final String searchQuery;
  final Map<String, bool> selectedUsersMap;

  const OptimizedUserSelectionWidget({
    super.key,
    required this.users,
    required this.onUserToggle,
    required this.onSearchChanged,
    required this.searchQuery,
    required this.selectedUsersMap,
  });

  @override
  State<OptimizedUserSelectionWidget> createState() =>
      _OptimizedUserSelectionWidgetState();
}

class _OptimizedUserSelectionWidgetState
    extends State<OptimizedUserSelectionWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildSearchField(),
        HSpacing(16),
        _buildSelectedUsersRow(),
        _buildSelectionStats(),
        HSpacing(12),
        Expanded(child: _buildUserGrid()),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.superLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.superLightGrey,
          hintText: 'Search friends...',
          hintStyle: TextStyle(fontSize: 14, color: AppColor.mediumGrey),
          prefixIcon: Icon(Icons.search, color: AppColor.mediumGrey),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.backgroundColor),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.backgroundColor),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.backgroundColor),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.errorRed),
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon:
              widget.searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: AppColor.mediumGrey),
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearchChanged('');
                    },
                  )
                  : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSelectedUsersRow() {
    return Observer(
      builder: (_) {
        final selectedUsers = context.postStore.shareUserLists;

        if (selectedUsers.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected (${selectedUsers.length})',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.defaultColor,
                  ),
                ),
                TextButton(
                  onPressed: () => context.postStore.unselectAllUsers(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColor.defaultColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            HSpacing(8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4),
                itemCount: selectedUsers.length,
                itemBuilder: (context, index) {
                  final user = selectedUsers[index];
                  return _SelectedUserChip(
                    user: user,
                    onRemove: () => context.postStore.toggleUserSelection(user),
                  );
                },
              ),
            ),
            HSpacing(12),
          ],
        );
      },
    );
  }

  Widget _buildSelectionStats() {
    return Observer(
      builder: (_) {
        final selectedCount = context.postStore.selectedUsersCount;

        if (selectedCount > 0) {
          return SizedBox.shrink(); // Hide since we show selected users above
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.superLightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColor.mediumGrey),
              WSpacing(8),
              Text(
                'Select friends to share with',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.mediumGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserGrid() {
    return Observer(
      builder: (_) {
        final filteredUsers = _getFilteredUsers();

        if (filteredUsers.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85, // Adjusted for better proportions
          ),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return Observer(
              builder: (_) {
                return _UserSelectionTile(
                  key: ValueKey(user.id),
                  user: user,
                  onToggle: () => widget.onUserToggle(user),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColor.mediumGrey),
          HSpacing(16),
          Text(
            widget.searchQuery.isNotEmpty
                ? 'No friends found matching "${widget.searchQuery}"'
                : 'No friends available',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColor.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.searchQuery.isNotEmpty) ...[
            HSpacing(8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                widget.onSearchChanged('');
              },
              child: Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }

  List<UserEntity> _getFilteredUsers() {
    if (widget.searchQuery.isEmpty) {
      return widget.users;
    }

    final query = widget.searchQuery.toLowerCase();
    return widget.users.where((user) {
      final fullname = user.fullname.toLowerCase();
      final username = user.username.toLowerCase();
      return fullname.contains(query) || username.contains(query);
    }).toList();
  }
}

class _SelectedUserChip extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onRemove;

  const _SelectedUserChip({required this.user, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AvatarBoxShadowWidget(
                imageUrl:
                    user.avatar.isNotEmpty
                        ? user.avatar
                        : ImagePath.avatarDefault,
                width: 50,
                height: 50,
              ),
              Positioned(
                right: -2,
                top: -2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColor.errorRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          HSpacing(4),
          SizedBox(
            width: 60,
            child: Text(
              user.fullname.isNotEmpty ? user.fullname : user.username,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.defaultColor,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserSelectionTile extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onToggle;

  const _UserSelectionTile({
    super.key,
    required this.user,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isSelected = context.postStore.selectedUsersMap[user.id] ?? false;

        return GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColor.defaultColor : Colors.transparent,
                width: 2,
              ),
              color:
                  isSelected
                      ? AppColor.defaultColor.withValues(alpha: 0.05)
                      : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    AvatarBoxShadowWidget(
                      imageUrl:
                          user.avatar.isNotEmpty
                              ? user.avatar
                              : ImagePath.avatarDefault,
                      width: 60,
                      height: 60,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: AnimatedScale(
                        scale: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColor.defaultColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                HSpacing(8),
                Text(
                  user.fullname.isNotEmpty ? user.fullname : user.username,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color:
                        isSelected
                            ? AppColor.defaultColor
                            : AppColor.defaultColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (user.fullname.isNotEmpty && user.username.isNotEmpty)
                  Text(
                    '@${user.username}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColor.mediumGrey,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

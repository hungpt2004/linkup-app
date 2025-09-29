import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/core/constants/message/message_debug.dart';
import 'package:vdiary_internship/presentation/pages/friends/store/friend_store.dart';
import 'package:vdiary_internship/presentation/pages/friends/store/user_store.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';

class FriendController {
  FriendStore friendStore = FriendStore();
  UserStore userStore = UserStore();
  FriendController(this.friendStore, this.userStore);

  // Lấy số bạn chung cho một userId
  Future<int> getMutualFriendsCountForUser(String userId) async {
    try {
      final result = await friendStore.getMutualFriendsCount([userId]);
      return result[userId] ?? 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  // Check isFriend ? - Kiểm tra người dùng có phải bạn bè không ?
  Future<bool> checkIsFriend(String userId) async {
    try {
      final checkValue = friendStore.friends.any((item) => item.id == userId);
      return checkValue;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  // Get following (users the current user is following)
  Future<void> handleGetFollowing() async {
    try {
      final success = await friendStore.loadFollowing();
      if (success) debugPrint('Loaded following successfully');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Follow user
  Future<void> handleFollowUser(String recipientId) async {
    try {
      final success = await friendStore.followUser(recipientId);
      if (success) {
        userStore.suggestions.removeWhere((item) => item.id == recipientId);
        debugPrint('Followed user successfully');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Unfollow user
  Future<void> handleUnfollowUser(String recipientId) async {
    try {
      final success = await friendStore.unfollowUser(recipientId);
      friendStore.following.removeWhere((item) => item.id == recipientId);
      if (success) debugPrint('Unfollowed user successfully');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Unfriend
  Future<void> handleUnfriendUser(String friendId) async {
    try {
      final success = await friendStore.unfriendUser(friendId);
      friendStore.friends.removeWhere((item) => item.id == friendId);
      if (success) debugPrint('Unfriended user successfully');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Send follow request
  Future<void> handleSendFollowRequest(String recipientId) async {
    try {
      final success = await friendStore.sendFollowRequest(recipientId);
      if (success) debugPrint('Sent follow request successfully');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Get followers (type == 'follow')
  Future<void> handleGetFollowers() async {
    try {
      final success = await friendStore.loadFollowers();
      if (success) debugPrint('Loaded followers successfully');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Get all friends
  Future<void> handleGetAllFriends(BuildContext context) async {
    try {
      final success = await friendStore.loadFriends();
      if (success) debugPrint(MessageDebug.fetchListSuccess);
      debugPrint(MessageDebug.fetchListFail);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> handleGetAllOwnRequests() async {
    try {
      final success = await friendStore.loadOwnFriendRequests();
      if (success) debugPrint(MessageDebug.fetchListSuccess);
      debugPrint(MessageDebug.fetchListFail);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Handle reject add friend
  Future<void> handleRejectAddFriendRequest(String recipientId) async {
    try {
      final success = await friendStore.rejectFriendRequest(recipientId);
      friendStore.friendRequestsTest.removeWhere(
        (item) => item.id == recipientId,
      );
      if (success) {
        debugPrint(MessageDebug.fetchListSuccess);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Get all request
  Future<void> handleGetAllRequests() async {
    try {
      final success = await friendStore.loadFriendRequests();
      if (success) debugPrint(MessageDebug.fetchListRequestSuccess);
      debugPrint(MessageDebug.fetchListRequestFail);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Add friend
  Future<void> handleAddFriend(String recipientId) async {
    try {
      final succes = await friendStore.sendFriendRequest(recipientId);
      // userStore.listUsers.removeWhere((item) => item.id! == recipientId);
      friendStore.saveSentRequests.add(recipientId);
      if (succes) {
        debugPrint(MessageDebug.addSuccess);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Accept friend
  Future<void> handleAcceptRequests(
    String friendId,
    BuildContext context,
  ) async {
    try {
      final success = await friendStore.acceptFriendRequest(friendId);
      friendStore.friendRequestsTest.removeWhere((user) => user.id == friendId);
      if (success) {
        if (context.mounted) {
          return ToastAppWidget.showSuccessToast(
            context,
            MessageDebug.acceptSuccess,
            onUndo: () {
              AppNavigator.pop(context);
            },
          );
        }
      }
    } catch (error) {
      debugPrint(error.toString());
      if (context.mounted) {
        return ToastAppWidget.showSuccessToast(
          context,
          error.toString(),
          onUndo: () {
            AppNavigator.pop(context);
          },
        );
      }
    }
  }
}

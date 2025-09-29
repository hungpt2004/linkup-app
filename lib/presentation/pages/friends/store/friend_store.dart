import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/friend/friend_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/friends/service/friend_service.dart';

part 'friend_store.g.dart';

// ignore: library_private_types_in_public_api
class FriendStore = _FriendStore with _$FriendStore;

abstract class _FriendStore with Store {
  final FriendService _friendService = FriendService();

  @observable
  ObservableList<UserModel> following = ObservableList<UserModel>();

  @observable
  ObservableList<UserModel> unfriended = ObservableList<UserModel>();

  @observable
  ObservableList<UserModel> unfollowed = ObservableList<UserModel>();

  @observable
  ObservableList<UserModel> followers = ObservableList<UserModel>();

  @observable
  String? status;

  // Observable states
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? successMessage;

  @observable
  ObservableList<UserModel> friends = ObservableList<UserModel>();

  @observable
  ObservableList<FriendModel> sentRequests = ObservableList<FriendModel>();

  @observable
  ObservableList<UserModel> historyRequests = ObservableList<UserModel>();

  @observable
  ObservableList<UserModel> friendRequestsTest = ObservableList<UserModel>();

  // Dùng để lưu trữ những request đã gửi đi
  @observable
  ObservableList<String> saveSentRequests = ObservableList<String>();

  @observable
  ObservableList<Map<String, dynamic>> suggestions =
      ObservableList<Map<String, dynamic>>();

  @observable
  String searchQuery = '';

  // Actions
  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setStatus(String value) => status = value;

  @action
  void setSuccessMessage(String? value) => successMessage = value ?? '';

  @action
  void setErrorMessage(String? value) => errorMessage = value ?? '';

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  // Trả về số lượng bạn chung với nhiều userId
  @action
  Future<Map<String, int>> getMutualFriendsCount(List<String> targetIds) async {
    final result = <String, int>{};
    try {
      final response = await _friendService.findMutualFriends(targetIds);
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        for (final id in targetIds) {
          if (data.containsKey(id)) {
            final info = data[id] as Map<String, dynamic>;
            final count = info['count'] as int? ?? 0;
            result[id] = count;
          } else {
            result[id] = 0;
          }
        }
      }
      return result;
    } catch (e) {
      for (final id in targetIds) {
        result[id] = 0;
      }
      return result;
    }
  }

  // Trả về danh sách bạn chung với nhiều userId
  @action
  Future<Map<String, List<UserModel>>> getMutualFriends(
    List<String> targetIds,
  ) async {
    final result = <String, List<UserModel>>{};
    try {
      final response = await _friendService.findMutualFriends(targetIds);
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        for (final id in targetIds) {
          if (data.containsKey(id)) {
            final info = data[id] as Map<String, dynamic>;
            final friendsList = info['mutualFriends'] as List<dynamic>?;
            if (friendsList != null) {
              result[id] =
                  friendsList.map((json) => UserModel.fromJson(json)).toList();
            } else {
              result[id] = [];
            }
          } else {
            result[id] = [];
          }
        }
      }
      return result;
    } catch (e) {
      for (final id in targetIds) {
        result[id] = [];
      }
      debugPrint("$result");
      return result;
    }
  }

  // FOLLOW USER
  @action
  Future<bool> followUser(String recipientId) async {
    try {
      clearError();
      await _friendService.followUser(recipientId);
      setSuccessMessage('Followed user successfully');
      return true;
    } catch (e) {
      setError('Không thể follow: ${e.toString()}');
      return false;
    }
  }

  // UNFOLLOW USER
  @action
  Future<bool> unfollowUser(String recipientId) async {
    try {
      clearError();
      await _friendService.unfollowUser(recipientId);
      setSuccessMessage('Unfollowed user successfully');
      return true;
    } catch (e) {
      setError('Không thể unfollow: ${e.toString()}');
      return false;
    }
  }

  // UNFRIEND
  @action
  Future<bool> unfriendUser(String friendId) async {
    try {
      clearError();
      await _friendService.unfriendUser(friendId);
      setSuccessMessage('Unfriended user successfully');
      return true;
    } catch (e) {
      setError('Không thể hủy kết bạn: ${e.toString()}');
      return false;
    }
  }

  // GỬI FOLLOW REQUEST
  @action
  Future<bool> sendFollowRequest(String recipientId) async {
    try {
      clearError();
      await _friendService.sendFollowRequest(recipientId);
      setSuccessMessage('Đã gửi follow request');
      return true;
    } catch (e) {
      setError('Không thể gửi follow request: ${e.toString()}');
      return false;
    }
  }

  // LOAD FOLLOWERS (type == 'follow')
  @action
  Future<bool> loadFollowers() async {
    try {
      setLoading(true);
      clearError();
      final response = await _friendService.getFollowers();
      final listRequests = response['data']['followers'] as List<dynamic>;

      // Lọc theo type == 'follow'
      final filtered =
          listRequests.where((item) {
            final mapUser = item as Map<String, dynamic>;
            return mapUser['type'] == 'follow';
          }).toList();

      // Lấy populate của requester
      final listUserFollowers =
          filtered.map((item) {
            final mapUser = item as Map<String, dynamic>;
            final followerJson = mapUser['requester'] as Map<String, dynamic>?;
            if (followerJson == null) {
              throw Exception('Missing "requester" field');
            }
            return UserModel.fromJson(followerJson);
          }).toList();
      // Lưu vào list follower
      followers
        ..clear()
        ..addAll(listUserFollowers);

      return true;
    } catch (e) {
      setError('Không thể tải followers: ${e.toString()}');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }

  @action
  Future<bool> loadFriends() async {
    try {
      setLoading(true);
      clearError();

      final response = await _friendService.findAllFriends();

      final friendList =
          (response['data']['friends'] as List<dynamic>)
              .map((json) => UserModel.fromJson(json))
              .toList();

      friends
        ..clear()
        ..addAll(friendList);

      setSuccessMessage('Load list friends success');
      return true;
    } catch (e) {
      setError('Can\'t load list friends: ${e.toString()}');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }

  // LOAD OWN REQUESTS
  Future<bool> loadOwnFriendRequests() async {
    try {
      setLoading(true);
      clearError();

      final response = await _friendService.findAllOwnRequests();

      final listRequests = response['data'] as List<dynamic>;

      // Chỉ lấy các request có type == 'friend_request'
      final filteredRequests =
          listRequests.where((item) {
            final mapUser = item as Map<String, dynamic>;
            return mapUser['type'] == 'friend_request';
          }).toList();

      // Lấy danh sách người dùng embededd
      final listUserRequests =
          filteredRequests.map((item) {
            final mapUser = item as Map<String, dynamic>;
            final requesterJson = mapUser['recipient'] as Map<String, dynamic>?;
            if (requesterJson == null) {
              throw Exception('Missing "recipient" field');
            }
            return UserModel.fromJson(requesterJson);
          }).toList();

      historyRequests
        ..clear()
        ..addAll(listUserRequests);

      return true;
    } catch (error) {
      setError(error.toString());
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }

  // LOAD FRIEND REQUESTS
  @action
  Future<bool> loadFriendRequests() async {
    try {
      setLoading(true);
      clearError();

      final response = await _friendService.findAllRequests();

      // Lấy danh sách requests từ response
      final listRequests = response['data']['requests'] as List<dynamic>;

      // Chỉ lấy các request có type == 'friend_request'
      final filteredRequests =
          listRequests.where((item) {
            final mapUser = item as Map<String, dynamic>;
            return mapUser['type'] == 'friend_request';
          }).toList();

      // Lấy danh sách người dùng embedded
      final listUserRequests =
          filteredRequests.map((item) {
            final mapUser = item as Map<String, dynamic>;
            final requesterJson = mapUser['requester'] as Map<String, dynamic>?;
            if (requesterJson == null) {
              throw Exception('Missing "requester" field');
            }
            return UserModel.fromJson(requesterJson);
          }).toList();

      friendRequestsTest
        ..clear()
        ..addAll(listUserRequests);

      return true;
    } catch (e) {
      setError('Không thể tải lời mời kết bạn: ${e.toString()}');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }

  // ACCEPT FRIEND
  @action
  Future<bool> acceptFriendRequest(String recipientId) async {
    try {
      clearError();

      await _friendService.acceptRequestAddFriend(recipientId);

      return true;
    } catch (e) {
      setError('Không thể chấp nhận lời mời: ${e.toString()}');
      return false;
    }
  }

  // REJECT ADD FRIEND REQUEST
  @action
  Future<bool> rejectFriendRequest(String recipientId) async {
    try {
      setLoading(true);
      clearError();

      await _friendService.rejectAddFriendRequest(recipientId);

      return true;
    } catch (e) {
      setError('Không thể từ chối lời mời: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ADD FRIEND
  @action
  Future<bool> sendFriendRequest(String recipientId) async {
    try {
      clearError();

      var response = await _friendService.createAddFriendRequest(recipientId);

      var pendingRequestData =
          (response['data'] as List<dynamic>)
              .map((item) => FriendModel.fromJson(item))
              .toList();

      sentRequests
        ..clear()
        ..addAll(pendingRequestData);

      return true;
    } catch (e) {
      setError('Không thể gửi lời mời: ${e.toString()}');
      return false;
    }
  }

  // LOAD FOLLOWING (type == 'following')
  @action
  Future<bool> loadFollowing() async {
    try {
      setLoading(true);
      clearError();
      final response = await _friendService.getFollowing();
      final listRequests = response['data']['following'] as List<dynamic>;

      // Chỉ lấy các request có type == 'follow' và status == 'following'
      final filteredRequests =
          listRequests.where((item) {
            final mapUser = item as Map<String, dynamic>;
            return mapUser['type'] == 'follow' &&
                mapUser['status'] == 'following';
          }).toList();

      final listUserRequests = <UserModel>[];
      for (final item in filteredRequests) {
        final mapUser = item as Map<String, dynamic>;
        final recipientJson = mapUser['recipient'] as Map<String, dynamic>?;
        if (recipientJson != null) {
          listUserRequests.add(UserModel.fromJson(recipientJson));
        }
      }

      following
        ..clear()
        ..addAll(listUserRequests);
      return true;
    } catch (e) {
      setError('Không thể tải following: ${e.toString()}');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 300),
        () => setLoading(false),
      );
    }
  }

  @computed
  int get friendsCount => friends.length;

  @computed
  int get pendingRequestsCount => sentRequests.length;

  @computed
  bool get hasError => errorMessage != null;

  // Initialize all data
  @action
  Future<void> initialize() async {
    await Future.wait([
      loadFriends(),
      loadFriendRequests(),
      loadFollowers(),
      loadFollowing(),
    ]);
  }

  @action
  Future<void> initializeFriends() async {
    await Future.wait([loadFriends()]);
  }
}

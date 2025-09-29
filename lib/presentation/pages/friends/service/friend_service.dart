import 'package:flutter/cupertino.dart';
import 'package:vdiary_internship/data/repositories_impl/friend_repository_impl.dart';
import 'package:vdiary_internship/data/repositories_impl/user_repository_impl.dart';

class FriendService {
  // Follow user
  Future<Map<String, dynamic>> followUser(String recipientId) async {
    try {
      var response = await _friendRepositoryImpl.follow(recipientId);
      return response; 
    } catch (error) {
      rethrow;
    }
  }

  // Unfollow user
  Future<Map<String, dynamic>> unfollowUser(String recipientId) async {
    try {
      var response = await _friendRepositoryImpl.unfollow(recipientId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Unfriend
  Future<Map<String, dynamic>> unfriendUser(String friendId) async {
    try {
      var response = await _friendRepositoryImpl.unfriend(friendId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Gửi follow request (giống follow)
  Future<Map<String, dynamic>> sendFollowRequest(String recipientId) async {
    try {
      var response = await _friendRepositoryImpl.follow(recipientId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Lấy danh sách followers (lọc type == 'follow')
  Future<Map<String, dynamic>> getFollowers() async {
    try {
      var response = await _friendRepositoryImpl.findAllFollower();
      debugPrint('${response.length}');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  final FriendRepositoryImpl _friendRepositoryImpl = FriendRepositoryImpl();
  final UserRepositoryImpl _userRepositoryImpl = UserRepositoryImpl();

  // Lấy tất cả user trong app
  Future<Map<String, dynamic>> findAllUser() async {
    try {
      var response = await _userRepositoryImpl.findAllUser();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Lấy bạn chung
  Future<Map<String, dynamic>> findMutualFriends(List<String> targetIds) async {
    try {
      var response = await _friendRepositoryImpl.findMutualFriends(targetIds);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Lấy tất cả bạn
  Future<Map<String, dynamic>> findAllFriends() async {
    try {
      var response = await _friendRepositoryImpl.findAllFriend();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Lấy các request từ người khác -> mình
  Future<Map<String, dynamic>> findAllRequests() async {
    try {
      var response = await _friendRepositoryImpl.findAllRequest();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> findAllOwnRequests() async {
    try {
      var response = await _friendRepositoryImpl.findAllOwnRequest();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Accept friend
  Future<Map<String, dynamic>> acceptRequestAddFriend(String friendId) async {
    try {
      var response = await _friendRepositoryImpl.accept(friendId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Add friend
  Future<Map<String, dynamic>> createAddFriendRequest(
    String recipientId,
  ) async {
    try {
      var response = await _friendRepositoryImpl.createRequest(recipientId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Reject request
  Future<Map<String, dynamic>> rejectAddFriendRequest(
    String recipientId,
  ) async {
    try {
      var response = await _friendRepositoryImpl.rejectRequest(recipientId);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Lấy danh sách following
  Future<Map<String, dynamic>> getFollowing() async {
    try {
      var response = await _friendRepositoryImpl.findAllFollowing();
      return response;
    } catch (error) {
      rethrow;
    }
  }
}

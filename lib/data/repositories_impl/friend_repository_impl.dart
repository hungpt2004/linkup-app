import 'package:flutter/widgets.dart';
import '../../core/constants/api/end_point.dart';
import '../../core/exception/exception_type.dart';
import '../../core/network/dio_client.dart';
import '../../domain/repositories/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  @override
  Future<Map<String, dynamic>> createRequest(String recipientId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'recipientId': recipientId, 'action': TypeAction.send.name},
      );
      debugPrint('Dữ liệu từ request add: ${response.data}');
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRequest() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> findAllFriend() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findListUser}',
        queryParameters: {'type': TypeRequest.friends.name},
      );
      debugPrint('Dữ liệu từ friends: ${response.data}');
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findAllRequest() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findListUser}',
        queryParameters: {'type': TypeRequest.requests.name},
      );
      debugPrint("Dữ liệu từ friends request: ${response.data}");
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findAllOwnRequest() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findOwnRequestByUserId}',
      );
      debugPrint("Dữ liệu từ friends: ${response.data}");
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> follow(String recipientId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'recipientId': recipientId, 'action': TypeAction.follow.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> rejectRequest(String requestId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'requestId': requestId, 'action': TypeAction.reject.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> unfollow(String recipientId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'recipientId': recipientId, 'action': TypeAction.unfollow.name},
      );
      debugPrint('Unfollow ${response.data}');
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> unfriend(String friendId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'friendId': friendId, 'action': TypeAction.unfriend.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> accept(String friendId) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.friendAction}',
        data: {'recipientId': friendId, 'action': TypeAction.accept.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findAllFollower() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findListUser}',
        queryParameters: {'type': TypeRequest.followers.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findAllFollowing() async {
    try {
      var response = await baseUrlHasToken.get(
        '${ApiEndPoint.findListUser}',
        queryParameters: {'type': TypeRequest.following.name},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }

  @override
  Future<Map<String, dynamic>> findMutualFriends(List<String> targetIds) async {
    try {
      var response = await baseUrlHasToken.post(
        '${ApiEndPoint.findAllMutualFriends}',
        data: {"targetIds": targetIds},
      );
      return response.data;
    } catch (error) {
      throw ServerException(errorMessage: error.toString(), code: 'UNKNOWN');
    }
  }
}

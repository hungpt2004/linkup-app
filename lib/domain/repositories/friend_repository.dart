abstract class FriendRepository {
  // GET
  Future<Map<String, dynamic>> findAllFriend();
  Future<Map<String, dynamic>> findAllRequest();
  Future<Map<String, dynamic>> findAllOwnRequest();
  Future<Map<String, dynamic>> findAllFollowing();
  Future<Map<String, dynamic>> findAllFollower();
  Future<Map<String, dynamic>> findMutualFriends(List<String> targetIds);

  Future<Map<String, dynamic>> createRequest(String recipientId);
  Future<Map<String, dynamic>> deleteRequest();
  Future<Map<String, dynamic>> rejectRequest(String recipientId);
  Future<Map<String, dynamic>> accept(String friendId);
  Future<Map<String, dynamic>> unfriend(String friendId);
  Future<Map<String, dynamic>> follow(String recipientId);
  Future<Map<String, dynamic>> unfollow(String recipientId);
}

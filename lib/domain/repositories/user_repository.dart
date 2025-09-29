abstract class UserRepository {
  Future<Map<String, dynamic>> findAllUser();
  Future<Map<String, dynamic>> findOneById(String userId);
}
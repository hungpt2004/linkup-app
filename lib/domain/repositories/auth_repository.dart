import '../../data/models/user/user_model.dart';

abstract class AuthRepository {
  Future<List<UserModel>> findAll();
  Future<Map<String, dynamic>> profileUser();
  Future<Map<String, dynamic>> signIn(String email, String password);
  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  );
  Future<Map<String, dynamic>> updateAvatar(String imagePath);
  Future<Map<String, dynamic>> updateBackground(String imagePath);
}

import 'package:vdiary_internship/data/repositories_impl/auth_repository_impl.dart';

class AuthService {
  final AuthRepositoryImpl _authRepositoryImpl = AuthRepositoryImpl();

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _authRepositoryImpl.signIn(email, password);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _authRepositoryImpl.signUp(name, email, password);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> profileUser() async {
    try {
      final response = await _authRepositoryImpl.profileUser();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadAvatar(String imagePath) async {
    try {
      final response = await _authRepositoryImpl.updateAvatar(imagePath);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadBackground(String imagePath) async {
    try {
      final response = await _authRepositoryImpl.updateBackground(imagePath);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}

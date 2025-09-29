import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/province/province_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/data/services/shared_preferences_service.dart';
import 'package:vdiary_internship/data/services/province_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/presence_service.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';

// RELATIVE IMPORT
import '../service/auth_service.dart';

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final ProvinceService _provinceService = ProvinceService();
  final AuthService _authService = AuthService();

  @observable
  List<ProvinceModel>? listProvinces;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingUpload = false;

  @observable
  bool isLoadingProvince = false;

  @observable
  bool isLoggedIn = false;

  @observable
  String? token;

  @observable
  String? errorMessage;

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isRememberMe = false;

  @observable
  String? successMessage;

  @observable
  Map<String, dynamic>? userInfo;

  @action
  void setName(String value) {
    name = value;
  }

  @action
  void setUserInfo(Map<String, dynamic> newUserInfo) {
    userInfo = newUserInfo;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setListProvinces(List<ProvinceModel> list) {
    listProvinces = list;
  }

  @action
  void setSuccessMessage(String? value) {
    successMessage = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setRememberMe(bool value) {
    isRememberMe = value;
  }

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setUploadLoading(bool value) {
    isLoadingUpload = value;
  }

  @action
  void setLoadingProvinces(bool value) {
    isLoadingProvince = value;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setToken(String newToken) {
    token = newToken;
  }

  @action
  void loadSavedCredentials() {
    isRememberMe = SharedPreferencesService.getRememberMe() ?? false;
    if (isRememberMe) {
      email = SharedPreferencesService.getEmail() ?? '';
      password = SharedPreferencesService.getPassword() ?? '';
    }
  }

  // Lấy các tỉnh thành Việt Nam
  @action
  Future<void> loadVietNamProvinces() async {
    try {
      clearError();
      var fetchData = await _provinceService.getVietNamProvinces();
      setListProvinces(fetchData);
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoadingProvinces(false);
    }
  }

  // Kiểm tra trạng thái đăng nhập
  @action
  Future<void> checkLoginStatus() async {
    debugPrint('=== CHECK LOGIN STATUS START ===');
    setLoading(true);
    try {
      final savedToken = SharedPreferencesService.getAccessToken();
      final savedUserId = SharedPreferencesService.getId();

      debugPrint('Saved Token: $savedToken');
      debugPrint('Saved UserId: $savedUserId');

      if (savedToken != null && savedToken.isNotEmpty) {
        token = savedToken;
        isLoggedIn = true;
        debugPrint('ID lưu trong local: $savedUserId');

        if (savedUserId != null && savedUserId.isNotEmpty) {
          debugPrint('Calling getProfileUser with userId: $savedUserId');
          final success = await getProfileUser();
          debugPrint('getProfileUser result: $success');
          debugPrint('UserInfo after getProfileUser: $userInfo');
        } else {
          debugPrint('No saved userId found');
        }
      } else {
        debugPrint('No saved token found');
        isLoggedIn = false;
        userInfo = null;
      }
    } catch (error) {
      debugPrint('CheckLoginStatus error: $error');
      isLoggedIn = false;
      userInfo = null;
      await SharedPreferencesService.clearDataLogin();
    } finally {
      setLoading(false);
      debugPrint('=== CHECK LOGIN STATUS END ===');
    }
  }

  // Get profile user
  @action
  Future<bool> getProfileUser() async {
    debugPrint('=== GET PROFILE USER START ===');
    try {
      clearError();
      debugPrint('Calling API findUserById...');
      final response = await _authService.profileUser();
      debugPrint('API Response: $response');

      // Kiểm tra và lấy user từ response
      final user = response['user'] as Map<String, dynamic>?;

      if (user != null && user.isNotEmpty) {
        userInfo = user;
        debugPrint('UserInfo set successfully: ${userInfo?['avatar']}');
        debugPrint('=== GET PROFILE USER SUCCESS ===');
        return true;
      }
      debugPrint('Response is empty or user not found');
      return false;
    } catch (error) {
      debugPrint('Lỗi khi lấy detail user ${error.toString()}');
      setError(error.toString());
      return false;
    } finally {
      debugPrint('=== GET PROFILE USER END ===');
    }
  }

  // Đăng nhập
  @action
  Future<bool> login() async {
    try {
      setLoading(true);
      clearError();

      final response = await _authService.signIn(email, password);
      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? '';
      final token = response['metadata']['accessToken'] as String? ?? '';
      final user = response['metadata']['user'] as Map<String, dynamic>;

      debugPrint('Trạng thái đăng nhập: $success');
      debugPrint('Message đăng nhập: $message');
      debugPrint('Token: $token');
      debugPrint('User: $user');
      debugPrint('UserId: ${user['id']}');
      debugPrint("ĐANG KIỂM TRA ĐIỀU KIỆN");

      // debugPrint('UserInfo: ${userInfo!['name']}');
      // debugPrint('IsLoggedIn: $isLoggedIn');
      // debugPrint('========================');

      // Kiểm tra success
      if (success == true) {
        setSuccessMessage(message);
        debugPrint("ĐANG Ở TRONG ĐIỀU KIỆN TRUE");
        if (email.isNotEmpty && password.isNotEmpty) {
          isLoggedIn = true;
          setToken(token);
          // Lưu dữ liệu vào local storage
          if (isRememberMe) {
            await SharedPreferencesService.setEmail(email);
            await SharedPreferencesService.setPassword(password);
            await SharedPreferencesService.setRememberMe(isRememberMe);
          }

          // Lưu vào local storage token
          await SharedPreferencesService.setAccessToken(token);
          await SharedPreferencesService.setId(user['id']);
          await SharedPreferencesService.setLoginStatus(true);

          // Set trạng thái online
          await PresenceService().setupPresence(user['id']);

          await getProfileUser();

          // Check if there's a postId to navigate to after login
          final postIdToNavigate =
              SharedPreferencesService.getPostIdToNavigate();
          if (postIdToNavigate != null && postIdToNavigate.isNotEmpty) {
            debugPrint(
              'Navigating to post detail after login: $postIdToNavigate',
            );
            // Clear the stored postId
            await SharedPreferencesService.clearPostIdToNavigate();
            // Navigate to post detail
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppNavigator.toPostDetail(
                AppNavigator.navigatorKey.currentContext!,
                postId: postIdToNavigate,
              );
            });
          }

          return true;
        } else {
          return false;
        }
      } else {
        setError(message.isNotEmpty ? message : 'Không tìm thấy người dùng');
        debugPrint('Tin nhắn lỗi $errorMessage');
        return false;
      }
    } catch (e) {
      setError('Account not found');
      return false;
    } finally {
      await Future.delayed(Duration(seconds: 2), () => setLoading(false));
    }
  }

  // Đăng ký
  @action
  Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      setLoading(true);
      clearError();

      debugPrint('Name: $name');
      debugPrint('Email: $email');
      debugPrint('Password: $password');
      debugPrint('Confirm Password: $confirmPassword');

      if (password != confirmPassword) {
        setError('Mật khẩu xác nhận không khớp');
        return false;
      }

      final response = await _authService.signUp(name, email, password);
      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? '';

      debugPrint('Success trả về: $success');
      debugPrint('Message trả về: $message');

      if (success) {
        setSuccessMessage(message);
        final userData = response['data'];
        if (userData != null) {
          try {
            final userModel = UserModel.fromJson(
              userData as Map<String, dynamic>,
            );
            userInfo = userModel.toJson();
            debugPrint('User hiện tại đăng nhập: $userInfo');
          } catch (error) {
            debugPrint('Lỗi khi parsing user data: $error');
          }
        }
        return true;
      } else {
        setError(message.isNotEmpty ? message : 'Register failed, Try again');
        return false;
      }
    } catch (e) {
      setError('Register failed: ${e.toString()}');
      return false;
    } finally {
      await Future.delayed(Duration(seconds: 2), () => setLoading(false));
    }
  }

  // Đăng xuất
  @action
  Future<void> logout(BuildContext context) async {
    try {
      setLoading(true);

      // Lấy userId trước khi clear userInfo
      final currentUserId = userInfo?['_id'] ?? '';

      // Xóa data login trong local-storage
      await SharedPreferencesService.clearLocalStorage();
      await SharedPreferencesService.clearDataLogin();
      await SharedPreferencesService.clearAccessToken();

      // Set offline status TRƯỚC khi clear userInfo
      if (currentUserId.isNotEmpty) {
        await PresenceService().setOfflineStatus(currentUserId);
      }

      // Clear user data
      userInfo = null;
      isLoggedIn = false;
      token = null;
      email = '';
      password = '';

      // Show success toast TRƯỚC khi navigate
      if (context.mounted) {
        setSuccessMessage('Đăng xuất thành công');

        // Delay để đảm bảo toast hiển thị trước khi navigate
        await Future.delayed(const Duration(milliseconds: 500));

        // Về trang sign in
        if (context.mounted) {
          AppNavigator.goNamed(context, 'signin');
        }
      }
    } catch (e) {
      setError('Đăng xuất thất bại: ${e.toString()}');
      debugPrint('❌ Logout error: $e');
    } finally {
      setLoading(false);
    }
  }

  // Quên mật khẩu
  @action
  Future<bool> forgotPassword(String email) async {
    try {
      setLoading(true);
      clearError();

      // await apiService.forgotPassword(email);

      // Mock implementation
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      setError('Gửi email thất bại: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Reset mật khẩu
  @action
  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      setLoading(true);
      clearError();

      // await apiService.resetPassword(token, newPassword);

      // Mock implementation
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      setError('Đặt lại mật khẩu thất bại: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<bool> uploadAvatar(String imagePath) async {
    try {
      clearError();
      setUploadLoading(true);
      await _authService.uploadAvatar(imagePath);
      await getProfileUser();
      return true;
    } catch (e) {
      setError('Upload avatar thất bại');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 500),
        () => setUploadLoading(false),
      );
    }
  }

  @action
  Future<bool> uploadBackground(String imagePath) async {
    try {
      clearError();
      setUploadLoading(true);
      await _authService.uploadBackground(imagePath);
      return true;
    } catch (e) {
      setError('Upload avatar thất bại');
      return false;
    } finally {
      await Future.delayed(
        Duration(milliseconds: 500),
        () => setUploadLoading(false),
      );
    }
  }

  // Kiểm tra xem form login có thiếu gì không
  @computed
  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  // Kiểm tra có lỗi hoặc không trả về bool
  @computed
  bool get hasError => errorMessage != null;
}

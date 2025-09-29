import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';

// RELATIVE IMPORT
import '../store/auth_store.dart';

class AuthController {
  final AuthStore authStore;

  AuthController({required this.authStore});

  // Sign In
  Future<void> handleSignIn(
    String email,
    String password,
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final success = await authStore.login();
      debugPrint('Đăng nhập trạng thái: $success');
      if (success == true) {
        if (context.mounted) {
          if (context.mounted) {
            // Điều hướng trước
            AppNavigator.toDashboard(
                context, tabIndex: 0);
          }

          // Đợi UI dashboard dựng xong mới show toast
          Future.delayed(const Duration(
              milliseconds: 100), () {
            // Get context from the next screen - avoid lost context
            final ctx = AppNavigator.navigatorKey
                .currentContext; // Lấy global context
            if (ctx != null) {
              ToastAppWidget.showSuccessToast(
                ctx,
                'Login successfully',
                onUndo: () {
                  AppNavigator.pop(ctx);
                },
              );
            }
          });
        }
      } else {
        if (authStore.hasError) {
          if (context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastAppWidget.showErrorToast(
                context,
                authStore.errorMessage ?? 'Đăng nhập thất bại',
                onUndo: () {
                  AppNavigator.pop(context);
                },
              );
            });
          }
        }
      }
    } catch (error) {
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ToastAppWidget.showErrorToast(
            context,
            authStore.errorMessage ?? 'Đăng nhập thất bại',
            onUndo: () {
              AppNavigator.pop(context);
            },
          );
        });
      }
    }
  }

  // Sign Up
  Future<void> handleSignUp(
    BuildContext context,
    String name,
    String email,
    String password,
    String confirmPassword,
    GlobalKey<FormState> formKey,
  ) async {
    try {
      final formState = formKey.currentState;
      if (formState == null || !formState.validate()) {
        return;
      }

      final success = await authStore.register(
        name,
        email,
        password,
        confirmPassword,
      );

      if (success) {
        if (context.mounted) {
          try {
            final message = authStore.successMessage ?? 'Đăng ký thành công!';
            debugPrint('Success message: $message');

            debugPrint('Showing success toast...');
            ToastAppWidget.showSuccessToast(
              context,
              message,
              onUndo: () {
                debugPrint('Toast onUndo called');
                try {
                  AppNavigator.pop(context);
                } catch (e) {
                  debugPrint('Error in toast onUndo: $e');
                }
              },
            );

            // Xóa success message
            authStore.setSuccessMessage('');

            // Điều hướng đến trang login
            AppNavigator.toLogin(context);
          } catch (e) {
            debugPrint('Error in success handling: $e');
          }
        }
      } else {
        if (authStore.hasError && context.mounted) {
          ToastAppWidget.showErrorToast(
            context,
            authStore.errorMessage ?? 'Đăng ký thất bại!',
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Lỗi: ${error.toString()}');
      }
    }
  }

  // Lấy profile user
  Future<void> handleGetProfileUser() async {
    final success = await authStore.getProfileUser();
    debugPrint(
      success ? 'Profile của user ${authStore.userInfo}' : 'Lấy profile lỗi',
    );
  }

  // Logout
  void handleLogout(BuildContext context) async {
    try {
      // Kiểm tra context validity trước khi thực hiện logout
      if (!context.mounted) {
        debugPrint('❌ Context not mounted, cannot logout');
        return;
      }

      // Show logout toast TRƯỚC khi clear user data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ToastAppWidget.showSuccessToast(context, 'Đang đăng xuất...');
        }
      });

      await authStore.logout(context);

      // Hiển thị success toast sau khi logout thành công
      if (authStore.successMessage != null && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ToastAppWidget.showSuccessToast(context, authStore.successMessage!);
          }
        });
      }

      // Handle errors
      if (authStore.hasError && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ToastAppWidget.showErrorToast(
              context,
              authStore.errorMessage ?? 'Lỗi đăng xuất',
            );
          }
        });
      }
    } catch (e) {
      debugPrint('❌ HandleLogout error: $e');
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ToastAppWidget.showErrorToast(
              context,
              'Có lỗi xảy ra khi đăng xuất',
            );
          }
        });
      }
    }
  }

  // Load provinces
  Future<void> loadVietNamProvinces() async {
    await authStore.loadVietNamProvinces();
  }

  // Lấy thông tin local storage
  void loadSavedCredentials() {
    authStore.loadSavedCredentials();
  }

  // Set up controller
  void setupTextControllers(
    TextEditingController? nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    // nameController.addListener(() {
    //   _authStore.setName(nameController.text);
    // });

    emailController.addListener(() {
      authStore.setEmail(emailController.text);
    });

    passwordController.addListener(() {
      authStore.setPassword(passwordController.text);
    });

    emailController.text = authStore.email;
    passwordController.text = authStore.password;
    // nameController.text = _authStore.name;
  }

  // Upload image
}

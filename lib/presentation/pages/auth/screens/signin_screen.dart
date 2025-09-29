import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../store/auth_store.dart';
import '../controller/auth_controller.dart';
import '../widgets/form_signin_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController _authController = AuthController(authStore: AuthStore());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authController.loadSavedCredentials();
    _setupControllers();
  }

  void _goToRegisterPage() {
    if (mounted) {
      context.pushNamed('signup');
    }
  }

  void _setupControllers() {
    _authController.setupTextControllers(
      null,
      emailController,
      passwordController,
    );
  }

  void _handleSignIn() async {
    await _authController.handleSignIn(
      emailController.text,
      passwordController.text,
      formKey,
      context,
    );
  }

  // Method handle remember me
  void handleRememberMeChanged(bool? value) {
    _authController.authStore.setRememberMe(value ?? false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: PaddingLayout.symmetric(
          horizontal: PaddingSizeApp.paddingSizeMedium,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HSpacing(80),
                SizedBox(
                  width: ResponsiveSizeApp(context).widthPercent(200),
                  height: ResponsiveSizeApp(context).heightPercent(200),
                  child: Center(child: Lottie.asset(ImagePath.lottieLoginForm)),
                ),

                HSpacing(20),

                // Observer để reactive với MobX state
                Observer(
                  builder:
                      (_) => PaddingLayout.all(
                        value: 12,
                        child: FormSignInWidget(
                          emailController: emailController,
                          passwordController: passwordController,
                          formKey: formKey,
                          login: _handleSignIn,
                          register: _goToRegisterPage,
                          isLoading: _authController.authStore.isLoading,
                          isRememberMe: _authController.authStore.isRememberMe,
                          onRememberMeChanged: handleRememberMeChanged,
                          errorMessage: _authController.authStore.errorMessage,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

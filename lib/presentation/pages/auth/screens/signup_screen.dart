import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../store/auth_store.dart';
import '../widgets/form_signup_widget.dart';
import '../controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = AuthController(authStore: AuthStore());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authController.loadSavedCredentials();
    _authController.loadVietNamProvinces();
    _authController.setupTextControllers(
      nameController,
      emailController,
      passwordController,
    );
  }

  void handleSignUp() async {
    await _authController.handleSignUp(
      context,
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
      formKey,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colorScheme.onPrimary,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            HSpacing(100),

            SizedBox(
              width: ResponsiveSizeApp(context).widthPercent(200),
              height: ResponsiveSizeApp(context).heightPercent(200),
              child: Center(child: Lottie.asset(ImagePath.lottieRegisterForm)),
            ),

            HSpacing(20),

            // Observer để reactive với MobX state
            Observer(
              builder:
                  (_) => Padding(
                    padding: EdgeInsets.all(
                      ResponsiveSizeApp(context).moderateScale(16),
                    ),
                    child: FormSignUpWidget(
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      addressController: addressController,
                      authStore: _authController.authStore,
                      register: handleSignUp,
                      formKey: formKey,
                      isLoading: _authController.authStore.isLoading,
                      errorMessage: _authController.authStore.errorMessage,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';
import 'package:stylish_store/features/auth/logic/controllers/auth_controller.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_button.dart';
import 'package:stylish_store/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:stylish_store/features/auth/data/validators/auth_validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _controller.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                const Text(
                  'Welcome \nBack!',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: _controller.usernameController,
                        hintText: 'Username or Email',
                        icon: Icons.person_outline,
                        isPassword: false,
                        validator: AuthValidators.validateEmailOrUsername,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _controller.passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: AuthValidators.validatePassword,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.forgotPasswordView,
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),
                      AuthButton(onPressed: _handleLogin, text: 'Login'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// Social Login
                SocialLoginButtons(
                  onGooglePressed: () {},
                  onApplePressed: () {},
                  onFacebookPressed: () {},
                ),
                const SizedBox(height: 28),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff626262),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.signupView,
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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

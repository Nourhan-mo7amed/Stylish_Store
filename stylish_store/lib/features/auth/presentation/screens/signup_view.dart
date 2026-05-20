import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/features/auth/logic/controllers/auth_controller.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_button.dart';
import 'package:stylish_store/features/auth/data/validators/auth_validators.dart';
import 'package:stylish_store/features/auth/presentation/widgets/social_login_buttons.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      _controller.signup();
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
                  'Create an account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),

                /// Form
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
                      const SizedBox(height: 31),
                      AuthTextField(
                        controller: _controller.passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: AuthValidators.validatePassword,
                      ),
                      const SizedBox(height: 31),
                      AuthTextField(
                        controller: _controller.confirmPasswordController,
                        hintText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          return AuthValidators.validateConfirmPassword(
                            value,
                            _controller.passwordController.text,
                          );
                        },
                      ),
                      SizedBox(height: 19),

                      /// Terms Text
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By clicking the ',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff626262),
                              ),
                            ),
                            TextSpan(
                              text: 'Register',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' button, you agree to the public offer',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff626262),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 38),

                      AuthButton(
                        onPressed: _handleSignup,
                        text: 'Create Account',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                /// Social Login
                SocialLoginButtons(
                  onGooglePressed: () {},
                  onApplePressed: () {},
                  onFacebookPressed: () {},
                ),
                const SizedBox(height: 28),

                /// Login Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff626262),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.loginView,
                          );
                        },
                        child: const Text(
                          'Login',
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

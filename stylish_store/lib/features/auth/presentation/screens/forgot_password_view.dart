import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';
import 'package:stylish_store/features/auth/logic/controllers/auth_controller.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_button.dart';
import 'package:stylish_store/features/auth/data/validators/auth_validators.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSendEmail() {
    if (_formKey.currentState!.validate()) {
      _controller.sendResetEmail();
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
                /// Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios, size: 24),
                ),
                const SizedBox(height: 32),

                /// Title
                const Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),

                /// Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: _controller.emailController,
                        hintText: 'Enter your email address',
                        icon: Icons.email_outlined,
                        isPassword: false,
                        validator: AuthValidators.validateEmail,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '* We will send you a message to set or reset your new password',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff626262),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),
                      AuthButton(onPressed: _handleSendEmail, text: 'Submit'),
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

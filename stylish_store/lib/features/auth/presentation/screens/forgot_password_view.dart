import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';
import 'package:stylish_store/features/auth/logic/cubits/forgot_password_cubit.dart';
import 'package:stylish_store/features/auth/logic/cubits/forgot_password_state.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_button.dart';
import 'package:stylish_store/features/auth/data/validators/auth_validators.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              _showSuccessDialog(context);
            } else if (state is ForgotPasswordFailure) {
              _showErrorDialog(context, state.failure.message);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your email to receive a password reset link',
                    style: TextStyle(fontSize: 14, color: Color(0xff626262)),
                  ),
                  const SizedBox(height: 36),
                  _buildForm(),
                  const SizedBox(height: 28),
                  _buildBackToLogin(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: _emailController,
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            validator: AuthValidators.validateEmail,
          ),
          const SizedBox(height: 38),
          BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) => AuthButton(
              onPressed: state is ForgotPasswordLoading
                  ? () {}
                  : _handleSendEmail,
              text: 'Send Reset Link',
              isLoading: state is ForgotPasswordLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLogin(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text(
          'Back to Login',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleSendEmail() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().sendResetEmail(
        email: _emailController.text,
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
          'Password reset link sent to your email. Please check your inbox.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}

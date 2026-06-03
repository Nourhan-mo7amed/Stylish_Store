import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';
import 'package:stylish_store/features/auth/logic/cubits/login_cubit.dart';
import 'package:stylish_store/features/auth/logic/cubits/login_state.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stylish_store/features/auth/presentation/widgets/auth_button.dart';
import 'package:stylish_store/features/auth/data/validators/auth_validators.dart';
import 'package:stylish_store/features/auth/presentation/widgets/social_login_buttons.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate directly to home after successful login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ تم تسجيل الدخول بنجاح!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.homeScreen,
                    arguments: state.user,
                  );
                }
              });
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ خطأ: ${state.failure.message}'),
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 36),
                  _buildForm(),
                  const SizedBox(height: 22),
                  _buildForgotPassword(context),
                  const SizedBox(height: 40),
                  SocialLoginButtons(
                    onGooglePressed: () {},
                    onApplePressed: () {},
                    onFacebookPressed: () {},
                  ),
                  const SizedBox(height: 28),
                  _buildSignupLink(context),
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
          const SizedBox(height: 31),
          AuthTextField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: AuthValidators.validatePassword,
          ),
          const SizedBox(height: 38),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) => AuthButton(
              onPressed: state is LoginLoading ? () {} : _handleLogin,
              text: 'Login',
              isLoading: state is LoginLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.forgotPasswordView),
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don\'t have an account? ',
            style: TextStyle(fontSize: 14, color: Color(0xff626262)),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, Routes.signupView),
            child: const Text(
              'Sign up',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }
}

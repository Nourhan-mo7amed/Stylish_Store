import 'package:flutter/material.dart';

class AuthController {
  // Login fields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Signup fields
  final confirmPasswordController = TextEditingController();

  // Forgot password fields
  final emailController = TextEditingController();

  // Login method
  void login() {
    // TODO: Implement login logic
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');
  }

  // Signup method
  void signup() {
    // TODO: Implement signup logic
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');
    print('Confirm Password: ${confirmPasswordController.text}');
  }

  // Send reset email method
  void sendResetEmail() {
    // TODO: Implement send reset email logic
    print('Reset email sent to: ${emailController.text}');
  }

  // Clear all controllers
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
  }
}

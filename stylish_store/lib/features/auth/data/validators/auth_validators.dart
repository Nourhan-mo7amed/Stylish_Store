class AuthValidators {
  /// Validate email/username
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username or email';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String passwordValue) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

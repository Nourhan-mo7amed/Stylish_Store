// Screens Exports
export 'package:stylish_store/splash_screen.dart';
export 'package:stylish_store/features/onboarding/onBoarding_screen.dart';
export 'package:stylish_store/features/home/presentation/screens/home_screen.dart';

// Models
export 'package:stylish_store/features/onboarding/onboarding_model.dart';

// Data
export 'package:stylish_store/features/onboarding/onboarding_data.dart';

// Widgets
export 'package:stylish_store/features/onboarding/widgets/onboarding_body.dart';
export 'package:stylish_store/features/onboarding/widgets/onboarding_bottom_row.dart';
export 'package:stylish_store/features/onboarding/widgets/onboarding_top_row.dart';

// Themes
export 'package:stylish_store/config/themes/app_colors.dart';
export 'package:stylish_store/config/themes/app_images.dart';
export 'package:stylish_store/config/themes/app_text_styles.dart';

class Routes {
  // Auth Routes
  static const String splashScreen = '/';
  static const String onboardingScreen = '/onboarding';
  static const String loginView = '/login';
  static const String signupView = '/signup';
  static const String forgotPasswordView = '/forgot-password';
  static const String homeScreen = '/home';
}

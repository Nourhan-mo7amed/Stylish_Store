import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes/routes.dart';
import 'splash_screen.dart';
import 'features/onboarding/onBoarding_screen.dart';
import 'features/auth/presentation/screens/login_view.dart';
import 'features/auth/presentation/screens/signup_view.dart';
import 'features/auth/presentation/screens/forgot_password_view.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.splashScreen: (context) => const SplashScreen(),
        Routes.loginView: (context) => const LoginView(),
        Routes.signupView: (context) => const SignupView(),
        Routes.forgotPasswordView: (context) => const ForgotPasswordView(),
        Routes.onboardingScreen: (context) => const OnBoardingScreen(),
      },
    );
  }
}

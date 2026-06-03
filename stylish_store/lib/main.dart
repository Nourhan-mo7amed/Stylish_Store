import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_store/features/auth/data/models/login_response.dart';
import 'package:stylish_store/features/auth/services/auth_service_locator.dart';
import 'config/routes/routes.dart';
import 'features/auth/presentation/screens/login_view.dart';
import 'features/auth/presentation/screens/signup_view.dart';
import 'features/auth/presentation/screens/forgot_password_view.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  // Initialize auth service
  AuthServiceLocator.setup();
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
        Routes.loginView: (context) => BlocProvider(
          create: (_) => AuthServiceLocator().loginCubit,
          child: const LoginView(),
        ),
        Routes.signupView: (context) => BlocProvider(
          create: (_) => AuthServiceLocator().registerCubit,
          child: const SignupView(),
        ),
        Routes.forgotPasswordView: (context) => BlocProvider(
          create: (_) => AuthServiceLocator().forgotPasswordCubit,
          child: const ForgotPasswordView(),
        ),
        Routes.onboardingScreen: (context) => const OnBoardingScreen(),
       Routes.homeScreen: (context) {
  final args =
      ModalRoute.of(context)?.settings.arguments as LoginResponse?;

  return HomeScreen();
},
      },
    );
  }
}

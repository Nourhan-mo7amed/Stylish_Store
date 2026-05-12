import 'dart:async';

import 'package:flutter/material.dart';
import 'config/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.onboardingScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.logo, width: 60),

            const SizedBox(width: 12),

            Image.asset(AppImages.stylishText, width: 120),
          ],
        ),
      ),
    );
  }
}

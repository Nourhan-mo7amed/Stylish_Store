import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';
import 'widgets/onboarding_top_row.dart';
import 'widgets/onboarding_body.dart';
import 'widgets/onboarding_bottom_row.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              /// TOP
              OnBoardingTopRow(currentPage: currentPage),

              /// BODY
              Expanded(
                child: PageView.builder(
                  controller: pageController,

                  itemCount: onboardingData.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return OnBoardingBody(model: onboardingData[index]);
                  },
                ),
              ),

              /// BOTTOM
              OnBoardingBottomRow(
                currentPage: currentPage,
                length: onboardingData.length,

                onNext: () {
                  if (currentPage < onboardingData.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // عند آخر صفحة، انتقل لصفحة اللوجين
                    Navigator.pushReplacementNamed(context, Routes.loginView);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

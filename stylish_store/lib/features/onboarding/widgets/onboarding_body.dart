import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';

class OnBoardingBody extends StatelessWidget {
  final OnBoardingModel model;

  const OnBoardingBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Image.asset(model.image, height: 320),

        const SizedBox(height: 40),

        Text(model.title, style: AppTextStyles.titleStyle),

        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Text(
            model.description,
            textAlign: TextAlign.center,

            style: AppTextStyles.descriptionStyle,
          ),
        ),
      ],
    );
  }
}

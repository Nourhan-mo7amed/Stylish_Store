import 'package:flutter/material.dart';
import 'package:stylish_store/config/themes/app_text_style.dart';
import 'package:stylish_store/config/themes/app_colors.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '- OR Continue with -',
          style: AppTextStyles.semiBold14.copyWith(
            color: const Color(0xff626262),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              imagePath: 'assets/icons/google.png',
              onPressed: onGooglePressed,
            ),
            const SizedBox(width: 20),
            SocialButton(
              imagePath: 'assets/icons/apple.png',
              onPressed: onApplePressed,
            ),
            const SizedBox(width: 20),
            SocialButton(
              imagePath: 'assets/icons/facebook.png',
              onPressed: onFacebookPressed,
            ),
          ],
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

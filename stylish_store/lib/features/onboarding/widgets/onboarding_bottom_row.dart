import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';
import 'package:stylish_store/config/themes/app_colors.dart';

class OnBoardingBottomRow extends StatelessWidget {
  final int currentPage;
  final int length;
  final VoidCallback onNext;

  const OnBoardingBottomRow({
    super.key,
    required this.currentPage,
    required this.length,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),

      child: Stack(
        alignment: Alignment.center,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(length, (dotIndex) {
              return Container(
                margin: const EdgeInsets.only(right: 6),

                width: currentPage == dotIndex ? 26 : 8,
                height: 8,

                decoration: BoxDecoration(
                  color: currentPage == dotIndex
                      ? AppColors.darkPrimary
                      : AppColors.grey4,

                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),

          Align(
            alignment: Alignment.centerRight,

            child: GestureDetector(
              onTap: onNext,

              child: Text("Next", style: AppTextStyles.nextButtonStyle),
            ),
          ),
        ],
      ),
    );
  }
}

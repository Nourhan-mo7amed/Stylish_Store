import 'package:flutter/material.dart';
import 'package:stylish_store/config/routes/routes.dart';

class OnBoardingTopRow extends StatelessWidget {
  final int currentPage;

  const OnBoardingTopRow({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${currentPage + 1}",
                  style: AppTextStyles.pageCounterStyle,
                ),

                TextSpan(
                  text: "/3",
                  style: AppTextStyles.pageCounterSlashStyle,
                ),
              ],
            ),
          ),

          const Text("Skip", style: AppTextStyles.skipButtonStyle),
        ],
      ),
    );
  }
}

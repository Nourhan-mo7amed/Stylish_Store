import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle descriptionStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textGrey,
    height: 1.6,
  );

  static final TextStyle pageCounterStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static final TextStyle pageCounterSlashStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.grey4,
  );

  static const TextStyle skipButtonStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle nextButtonStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static final TextStyle boldW70036 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );
}

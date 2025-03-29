import 'package:flutter/material.dart';
import 'package:solana_beach/config/constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ),
  );
}

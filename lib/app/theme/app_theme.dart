// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    );
  }
}

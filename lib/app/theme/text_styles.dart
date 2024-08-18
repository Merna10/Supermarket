import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/app/theme/colors.dart';

class AppTextStyles {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 96.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      color: AppColors.accentColor,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: AppColors.accentColor,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 25.0,
      fontWeight: FontWeight.normal,
      color: AppColors.accentColor,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 34.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      color: AppColors.accentColor,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: AppColors.accentColor,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      color: AppColors.accentColor,
    ),
    titleMedium: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.15,
      color: AppColors.accentColor,
    ),
    titleSmall: GoogleFonts.playfairDisplay(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.1,
      color: AppColors.accentColor,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: AppColors.accentColor,
    ),
    bodyMedium: GoogleFonts.playfairDisplay(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      color: AppColors.accentColor,
    ),
    labelLarge: GoogleFonts.playfairDisplay(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.25,
      color: AppColors.accentColor,
    ),
    labelMedium: GoogleFonts.playfairDisplay(
      fontSize: 20.0,
      letterSpacing: 1.25,
      color: AppColors.accentColor,
    ),
    bodySmall: GoogleFonts.playfairDisplay(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      color: AppColors.accentColor,
    ),
    labelSmall: GoogleFonts.playfairDisplay(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,

      letterSpacing: 1.5,
      color: AppColors.accentColor,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 96.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 25.0,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 34.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.playfairDisplay(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.playfairDisplay(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.1,
    ),
    bodyLarge: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.playfairDisplay(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    labelLarge: GoogleFonts.playfairDisplay(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.25,
    ),
    bodySmall: GoogleFonts.playfairDisplay(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
    ),
    labelSmall: GoogleFonts.playfairDisplay(
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.5,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0A0E1A);
  static const card = Color(0xFF141928);
  static const card2 = Color(0xFF1E2538);
  static const primary = Color(0xFF4A90D9);
  static const accent = Color(0xFF64B5F6);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8892A4);
  static const sunny = Color(0xFFFFB347);
  static const rainy = Color(0xFF64B5F6);
  static const cloudy = Color(0xFF90A4AE);
  static const stormy = Color(0xFF7E57C2);
  static const snowy = Color(0xFFE3F2FD);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.card,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

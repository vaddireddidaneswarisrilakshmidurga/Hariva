import 'package:flutter/material.dart';

class AppColors {
  // Define the color scheme as per requirements
  static const Color oliveGreen = Color(0xFF808000); // Primary color
  static const Color darkGreen = Color(0xFF556B2F);  // Secondary color
  static const Color lightBrown = Color(0xFFA67B5B); // Accent color
  static const Color white = Color(0xFFFFFFFF);      // Background color
  
  // Additional colors for UI elements
  static const Color errorRed = Color(0xFFB00020);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFC107);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.oliveGreen,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme(
        primary: AppColors.oliveGreen,
        secondary: AppColors.darkGreen,
        surface: AppColors.white,
        error: AppColors.errorRed,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: Colors.black87,
        onError: AppColors.white,
        brightness: Brightness.light,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 16,
        ),
        titleLarge: TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oliveGreen,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 60), // Large touch targets
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

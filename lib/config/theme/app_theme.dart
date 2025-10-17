import 'package:flutter/material.dart';
import 'package:aliance_weather/core/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData appTheme = ThemeData(
    fontFamily: "FormaDJR",
    scaffoldBackgroundColor: WeatherColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: WeatherColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: WeatherColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: WeatherColors.textPrimary),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: WeatherColors.primary,
      secondary: WeatherColors.secondary,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: WeatherColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: WeatherColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: WeatherColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: WeatherColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: WeatherColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: WeatherColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 16,
        color: WeatherColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 14,
        color: WeatherColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: "FormaDJR",
        fontSize: 12,
        color: WeatherColors.textSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WeatherColors.secondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: WeatherColors.primary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WeatherColors.primary,
        foregroundColor: WeatherColors.background,
        textStyle: const TextStyle(
          fontFamily: "FormaDJR",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: "FormaDJR",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

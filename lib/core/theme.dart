import 'package:flutter/material.dart';
import 'package:aliance_weather/core/colors.dart';

class WeatherTheme {
  WeatherTheme._();

  static final ThemeData appTheme = ThemeData(
    fontFamily: "FormaDJR",
    scaffoldBackgroundColor: WeatherColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: WeatherColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),

    colorScheme: ColorScheme.fromSeed(seedColor: WeatherColors.primary),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        textStyle: const TextStyle(
          fontFamily: "FormaDJR",
          color: WeatherColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontFamily: "FormaDJR",
          color: WeatherColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

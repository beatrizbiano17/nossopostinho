import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData tema = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.branco,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.azulMedio,
      primary: AppColors.azulMedio,
      secondary: AppColors.bege,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.azulClaro,
      foregroundColor: AppColors.azulEscuro,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.branco,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: AppColors.azulMedio,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: AppColors.azulMedio,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: AppColors.azulEscuro,
          width: 2,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.azulMedio,
        foregroundColor: AppColors.branco,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    ),
  );
}
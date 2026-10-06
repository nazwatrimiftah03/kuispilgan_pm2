import 'package:flutter/material.dart';

class AppColors {
  static const Color green = Color(0xFF1B5E20);
  static const Color greenLight = Color(0xFF2E7D32);
  static const Color gold = Color(0xFFF9A825);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [green, greenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: brightness,
    ).copyWith(secondary: AppColors.gold);

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );
  }
}
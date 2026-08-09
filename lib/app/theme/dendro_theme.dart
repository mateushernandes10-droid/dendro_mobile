import 'package:flutter/material.dart';

abstract final class DendroColors {
  static const primary = Color(0xFF012D1D);
  static const primarySoft = Color(0xFFC1ECD4);
  static const secondary = Color(0xFF3E6750);
  static const surface = Color(0xFFF9F9F8);
  static const surfaceMuted = Color(0xFFEDEEEE);
  static const outline = Color(0xFFC1C8C2);
  static const text = Color(0xFF191C1C);
  static const textMuted = Color(0xFF56605A);
  static const warning = Color(0xFF806500);
}

abstract final class DendroTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DendroColors.primary,
      brightness: Brightness.light,
      primary: DendroColors.primary,
      secondary: DendroColors.secondary,
      surface: DendroColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DendroColors.surface,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: DendroColors.surface,
        foregroundColor: DendroColors.text,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: DendroColors.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: DendroColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? DendroColors.primary
                : DendroColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DendroColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DendroColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DendroColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DendroColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

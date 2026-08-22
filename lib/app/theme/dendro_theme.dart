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
  static const darkReadableCard = Color(0xFFA9CBB4);
  static const darkReadableCardHighlight = Color(0xFFB8D6C0);
  static const darkReadableField = Color(0xFFDDEBDD);
  static const darkReadableBorder = Color(0xFF73957C);
  static const darkAction = Color(0xFF01452D);
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
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DendroColors.primary,
        foregroundColor: Colors.white,
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

  static ThemeData get dark {
    const darkSurface = Color(0xFF071611);
    const darkPanel = Color(0xFF0F241A);
    const darkPrimary = Color(0xFF9ED9B5);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: Brightness.dark,
      primary: darkPrimary,
      secondary: const Color(0xFFB7D7C3),
      surface: darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkSurface,
      cardColor: DendroColors.darkReadableCard,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkPanel,
        modalBackgroundColor: darkPanel,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkPanel,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
        contentTextStyle: const TextStyle(
          color: Color(0xFFDCE8DF),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      cardTheme: CardThemeData(
        color: DendroColors.darkReadableCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: DendroColors.darkReadableBorder),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkPanel,
        elevation: 4,
        indicatorColor: const Color(0xFF214B35),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFFB8C8BD),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFFB8C8BD),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DendroColors.darkAction,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF10251C),
        labelStyle: const TextStyle(color: Color(0xFFDCE8DF)),
        hintStyle: const TextStyle(color: Color(0xFF93A89B)),
        prefixIconColor: const Color(0xFFB8D9C4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF476052)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF476052)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimary, width: 1.4),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF173324),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: darkPrimary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DendroColors.darkAction,
        foregroundColor: Colors.white,
      ),
    );
  }
}

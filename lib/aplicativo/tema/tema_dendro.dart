import 'package:flutter/material.dart';

abstract final class CoresDendro {
  static const principal = Color(0xFF012D1D);
  static const principalSuave = Color(0xFFC1ECD4);
  static const secundario = Color(0xFF3E6750);
  static const superficie = Color(0xFFF9F9F8);
  static const superficieDiscreto = Color(0xFFEDEEEE);
  static const contorno = Color(0xFFC1C8C2);
  static const texto = Color(0xFF191C1C);
  static const textoDiscreto = Color(0xFF56605A);
  static const aviso = Color(0xFF806500);
  static const escuroLegivelCartao = Color(0xFFA9CBB4);
  static const escuroLegivelCartaoDestaque = Color(0xFFB8D6C0);
  static const escuroLegivelCampo = Color(0xFFDDEBDD);
  static const escuroLegivelBorda = Color(0xFF73957C);
  static const escuroAcao = Color(0xFF01452D);
}

abstract final class TemaDendro {
  static ThemeData get claro {
    final corEsquema = ColorScheme.fromSeed(
      seedColor: CoresDendro.principal,
      brightness: Brightness.light,
      primary: CoresDendro.principal,
      secondary: CoresDendro.secundario,
      surface: CoresDendro.superficie,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: corEsquema,
      scaffoldBackgroundColor: CoresDendro.superficie,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: CoresDendro.superficie,
        foregroundColor: CoresDendro.texto,
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
          side: const BorderSide(color: CoresDendro.contorno),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: CoresDendro.principalSuave,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            color: estados.contains(WidgetState.selected)
                ? CoresDendro.principal
                : CoresDendro.textoDiscreto,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CoresDendro.principal,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CoresDendro.principal,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresDendro.contorno),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresDendro.contorno),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CoresDendro.principal,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  static ThemeData get escuro {
    const escuroSuperficie = Color(0xFF071611);
    const escuroPainel = Color(0xFF0F241A);
    const escuroPrincipal = Color(0xFF9ED9B5);

    final corEsquema = ColorScheme.fromSeed(
      seedColor: escuroPrincipal,
      brightness: Brightness.dark,
      primary: escuroPrincipal,
      secondary: const Color(0xFFB7D7C3),
      surface: escuroSuperficie,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: corEsquema,
      scaffoldBackgroundColor: escuroSuperficie,
      cardColor: CoresDendro.escuroLegivelCartao,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: escuroSuperficie,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: escuroPainel,
        modalBackgroundColor: escuroPainel,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: escuroPainel,
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
        color: CoresDendro.escuroLegivelCartao,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: CoresDendro.escuroLegivelBorda),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: escuroPainel,
        elevation: 4,
        indicatorColor: const Color(0xFF214B35),
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFFB8C8BD),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            color: estados.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFFB8C8BD),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CoresDendro.escuroAcao,
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
          borderSide: const BorderSide(color: escuroPrincipal, width: 1.4),
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
        style: TextButton.styleFrom(foregroundColor: escuroPrincipal),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: escuroPrincipal,
          side: const BorderSide(color: escuroPrincipal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CoresDendro.escuroAcao,
        foregroundColor: Colors.white,
      ),
    );
  }
}

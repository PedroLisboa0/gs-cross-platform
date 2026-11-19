import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const ink = Color(0xFF173B38);
  static const forest = Color(0xFF176B5B);
  static const mint = Color(0xFFE6F4EF);
  static const canvas = Color(0xFFF5F8F6);
  static const amber = Color(0xFF9A5B00);
  static const red = Color(0xFFB3261E);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.dark,
      primary: const Color(0xFF79CDB7),
      surface: const Color(0xFF10201E),
      error: const Color(0xFFFFB4AB),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0B1715),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B1715),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF152725),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF314942)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF152725),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF466158)),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF10201E),
        indicatorColor: Color(0xFF274C43),
      ),
    );
  }

  static ThemeData get highContrast {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF005A43),
      onSecondary: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      error: Color(0xFF990000),
      onError: Color(0xFFFFFFFF),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFFFD54F),
      ),
    );
  }

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      primary: forest,
      surface: Colors.white,
      error: red,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5ECE8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E2DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E2DD)),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: mint,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
        ),
        headlineSmall: TextStyle(color: ink, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: ink, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: ink, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFF334945)),
        bodyMedium: TextStyle(color: Color(0xFF53635E)),
      ),
    );
  }
}

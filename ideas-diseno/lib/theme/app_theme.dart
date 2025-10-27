import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores principales - Identidad Barrio Napoli (Nuevo prompt Figma)
  static const Color primaryGreen = Color(0xFF006A4E); // Verde Marca
  static const Color primaryRed = Color(0xFFD93025); // Rojo CTA
  static const Color textDark = Color(0xFF333333); // Gris Pizarra
  static const Color accentCream = Color(0xFFFFFFFF); // Blanco Sólido
  static const Color lightGrey = Color(0xFFF5F5F5); // Gris Claro (Campos)
  static const Color mediumGrey = Color(0xFFE0E0E0); // Gris Borde
  static const Color darkGrey = Color(0xFFBDBDBD); // Gris inactivo

  // Colores secundarios
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFE53935);

  // Sombras
  static final BoxShadow shadowSmall = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  static final BoxShadow shadowMedium = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static final BoxShadow shadowLarge = BoxShadow(
    color: Colors.black.withOpacity(0.12),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  // Radios de esquinas
  static const double radiusSmall = 6;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;

  // Espaciados
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;

  // TextTheme - Montserrat 800/900 (títulos) + Inter (cuerpo)
  static TextTheme get textTheme => TextTheme(
        // Display - Montserrat 900 Black
        displayLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: textDark,
          letterSpacing: -0.3,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: -0.2,
        ),
        // Headline - Montserrat 800 ExtraBold
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: 0,
        ),
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: 0,
        ),
        // Title - Inter Bold
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.2,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.2,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.3,
        ),
        // Body - Inter Regular
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
          letterSpacing: 0,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
          letterSpacing: 0.1,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textDark,
          letterSpacing: 0.1,
        ),
        // Label - Inter Bold
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: accentCream,
          letterSpacing: 0.2,
        ),
      );

  // ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: lightGrey,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: primaryRed,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: accentCream,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: textDark,
        ),
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: accentCream,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(spacingM),
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: mediumGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: mediumGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      textTheme: textTheme,
    );
  }

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: primaryRed,
      tertiary: accentCream,
      surface: const Color(0xFF1E1E1E),
      onSurface: const Color(0xFFEEEEEE),
      error: errorRed,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 2,
      iconTheme: IconThemeData(color: Color(0xFFEEEEEE)),
      titleTextStyle: TextStyle(
        color: Color(0xFFEEEEEE),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
        textStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGreen,
        side: const BorderSide(color: primaryGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(spacingM),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFF444444)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFF444444), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFBBBBBB),
      ),
      hintStyle: GoogleFonts.montserrat(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A2A2A),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
    textTheme: darkTextTheme,
  );

  // Dark TextTheme
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFEEEEEE),
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFEEEEEE),
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFEEEEEE),
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFEEEEEE),
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFEEEEEE),
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFEEEEEE),
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFC0C0C0),
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFC0C0C0),
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFEEEEEE),
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFBBBBBB),
    ),
  );
}

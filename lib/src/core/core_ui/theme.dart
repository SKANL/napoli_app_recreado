import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación (Napoli Pizzeria)
class AppColors {
  // Paleta principal
  static const Color primaryGreen = Color(0xFF2E8B57);      // Verde Mar
  static const Color primaryRed = Color(0xFFCD5C5C);        // Rojo Indio
  static const Color backgroundBeige = Color(0xFFF5F5DC);   // Beige
  static const Color textDark = Color(0xFF2F4F4F);          // Gris Pizarra Oscuro
  static const Color accentTerracotta = Color(0xFFE9967A);  // Salmón Oscuro (Terracota)
  
  // Colores adicionales para UI
  static const Color white = Colors.white;
  static const Color grey = Color(0xff959595);
  static const Color transparent = Colors.transparent;

  // Colores de superficie y texto para tema claro (usa paleta corporativa)
  static const Color surfaceLight = Color(0xFFF5F5DC);      // Beige corporativo - Superficie clara
  static const Color onSurfaceLight = Color(0xFF2F4F4F);    // Gris Pizarra oscuro - Texto en superficie clara
  static const Color inputFillLight = Color(0xFFFFFFFF);    // Blanco para inputs (contraste sobre beige)

  // Colores de superficie y texto para tema oscuro (incorpora identidad corporativa)
  static const Color surfaceDark = Color(0xFF1A1A1A);       // Gris muy oscuro - Superficie oscura
  static const Color onSurfaceDark = Color(0xFFF5F5DC);     // Beige claro - Texto en superficie oscura (contraste con corporativo)
  static const Color cardDark = Color(0xFF2F4F4F);          // Gris Pizarra - Tarjetas en tema oscuro (corporativo)
  static const Color inputFillDark = Color(0xFF2A2A2A);     // Gris oscuro para inputs
  static const Color dividerDark = Color(0xFF3D5A3D);       // Verde oscuro (derivado del corporativo)
}

/// Clase de tema de la aplicación siguiendo Arquitectura V5
class AppTheme {
  /// Obtiene el tema claro de la aplicación
  static ThemeData getLightTheme() {
    // 1. Define el ColorScheme completo para el modo claro
    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,

      // Colores principales corporativos
      primary: AppColors.primaryGreen,        // Verde Mar - Principal
      onPrimary: AppColors.white,

      secondary: AppColors.accentTerracotta,  // Salmón/Terracota - Secundario
      onSecondary: AppColors.white,

      tertiary: AppColors.primaryRed,         // Rojo - Terciario/Acciones negativas
      onTertiary: AppColors.white,

      // Superficies y fondos: usar paleta corporativa
      surface: AppColors.surfaceLight,        // Beige corporativo
      onSurface: AppColors.onSurfaceLight,    // Gris Pizarra oscuro

      // Color de errores
      error: AppColors.primaryRed,
      onError: AppColors.white,
    );

    // 2. Construye el ThemeData usando el ColorScheme
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: 'Avenir',

      // El tema del texto usará `colorScheme.onSurface` por defecto
      textTheme: const TextTheme().apply(
        bodyColor: lightColorScheme.onSurface,
        displayColor: lightColorScheme.onSurface,
      ),

  // Fondo y superficie principales: usar surface para evitar API deprecated
  scaffoldBackgroundColor: lightColorScheme.surface,
  canvasColor: lightColorScheme.surface,

      // Tema de AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      // Tema de botones
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // Tema de cards
      cardTheme: CardThemeData(
        color: AppColors.backgroundBeige,  // Beige corporativo para cards
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Tema de inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Blanco para inputs sobre fondo beige corporativo
        fillColor: AppColors.inputFillLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGreen.withAlpha((0.4 * 255).round())),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightColorScheme.error),
        ),
      ),

      // Tema de iconos
      iconTheme: IconThemeData(
        color: lightColorScheme.onSurface,
      ),
    );
  }

  /// Obtiene el tema oscuro de la aplicación (opcional - mantenemos compatibilidad)
  static ThemeData getDarkTheme() {
    // Ajustes de color para modo oscuro: incorpora identidad corporativa
    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.primaryGreen,        // Verde Mar - Principal
      onPrimary: AppColors.white,

      secondary: AppColors.accentTerracotta,  // Salmón/Terracota - Secundario
      onSecondary: AppColors.white,

      tertiary: AppColors.primaryRed,         // Rojo - Terciario
      onTertiary: AppColors.white,

      // Superficies en oscuro: con identidad corporativa
      surface: AppColors.surfaceDark,         // Gris muy oscuro
      onSurface: AppColors.onSurfaceDark,     // Beige claro (contraste)

      error: AppColors.primaryRed,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: 'Avenir',

      textTheme: const TextTheme().apply(
        bodyColor: darkColorScheme.onSurface,
        displayColor: darkColorScheme.onSurface,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreen,  // Verde corporativo para consistencia
        foregroundColor: AppColors.white,
        elevation: 0,
      ),

  // Fondo general de la aplicación en modo oscuro (usar surface en lugar de background)
  scaffoldBackgroundColor: darkColorScheme.surface,
  // Color para elementos flotantes y barras
  canvasColor: darkColorScheme.surface,

  // Asegurar que los iconos sean visibles
  iconTheme: IconThemeData(color: darkColorScheme.onSurface),

  // Separadores y divisores ligeramente visibles
  dividerColor: AppColors.dividerDark,

      // Botones en modo oscuro: darles el color primario para mejor contraste
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
      ),

      // Tarjetas ligeramente más claras que el fondo para destacarse
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Inputs en oscuro: fondo tenue y bordes suaves con verde corporativo
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGreen.withAlpha((0.35 * 255).round())),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accentTerracotta, width: 2),
        ),
      ), dialogTheme: DialogThemeData(backgroundColor: darkColorScheme.surface),
    );
  }
}

// Mantener compatibilidad con código existente
final lightTheme = AppTheme.getLightTheme();
final darkTheme = AppTheme.getDarkTheme();

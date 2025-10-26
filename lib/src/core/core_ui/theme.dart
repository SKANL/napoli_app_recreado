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
}

/// Clase de tema de la aplicación siguiendo Arquitectura V5
class AppTheme {
  /// Obtiene el tema claro de la aplicación
  static ThemeData getLightTheme() {
    // 1. Define el ColorScheme completo para el modo claro
    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,

      // Colores principales
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.white,

      secondary: AppColors.accentTerracotta,
      onSecondary: AppColors.textDark,

  // Superficies y fondos: usar blanco/near-white para buena legibilidad
  surface: Color(0xFFF7F7F7),
  onSurface: Color(0xFF212121),

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
        color: lightColorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Tema de inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // ligero gris para inputs en light para separarlos del fondo beige
        fillColor: const Color(0xFFF2F2F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightColorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey.withAlpha((0.35 * 255).round())),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
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
    // Ajustes de color para modo oscuro: usar surface levemente más claro
    // para mejorar contraste en tarjetas y componentes dentro de diálogos.
    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.primaryGreen,
      onPrimary: AppColors.white,

      secondary: AppColors.accentTerracotta,
      onSecondary: AppColors.white,

  // Superficies en oscuro: mantener contraste pero evitar negro absoluto
  surface: Color(0xFF0B0B0B),
  onSurface: Color(0xFFF2F2F2),

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
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
      ),

  // Fondo general de la aplicación en modo oscuro (usar surface en lugar de background)
  scaffoldBackgroundColor: darkColorScheme.surface,
  // Color para elementos flotantes y barras
  canvasColor: darkColorScheme.surface,

  // Asegurar que los iconos sean visibles
  iconTheme: IconThemeData(color: darkColorScheme.onSurface),

  // Separadores y divisores ligeramente visibles
  dividerColor: const Color(0xFF2B2B2B),

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
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Inputs en oscuro: fondo tenue y bordes suaves
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF151515),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey.withAlpha((0.32 * 255).round())),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
      ), dialogTheme: DialogThemeData(backgroundColor: darkColorScheme.surface),
    );
  }
}

// Mantener compatibilidad con código existente
final lightTheme = AppTheme.getLightTheme();
final darkTheme = AppTheme.getDarkTheme();

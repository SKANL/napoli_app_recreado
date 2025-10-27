import 'package:flutter/material.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

/// Servicio para cargar imágenes locales con fallback a internet
class ImageHelper {
  /// Mapeo de nombres de productos a rutas locales
  static const Map<String, String> localImages = {
    'pizza_margherita': 'assets/images/pizza_margherita.jpg',
    'pizza_pepperoni': 'assets/images/pizza_pepperoni.jpg',
    'lasagna': 'assets/images/lasagna.jpg',
    'banner_promo': 'assets/images/barrio.jpg',
    'barrio_napoli_logo': 'assets/images/barrio_napoli_logo.jpg',
  };

  /// URLs de imágenes de placeholder profesionales (fallback)
  static const Map<String, String> placeholderImages = {
    'pizza_margherita':
        'https://images.unsplash.com/photo-1582284924141-17202d6e35ee?w=400&h=300&fit=crop',
    'pizza_pepperoni':
        'https://images.unsplash.com/photo-1534308983496-4d93bc592d68?w=400&h=300&fit=crop',
    'lasagna':
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
    'pasta_carbonara':
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
    'ravioles':
        'https://images.unsplash.com/photo-1621996346563-430f63602d4e?w=400&h=300&fit=crop',
    'fettuccine':
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
    'coca_cola':
        'https://images.unsplash.com/photo-1554866585-c4ea68f47591?w=400&h=300&fit=crop',
    'agua':
        'https://images.unsplash.com/photo-1516979187457-635ffe35ff91?w=400&h=300&fit=crop',
    'cerveza':
        'https://images.unsplash.com/photo-1608270861620-7c5f2a7c9e19?w=400&h=300&fit=crop',
    'tiramisú':
        'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=400&h=300&fit=crop',
    'brownie':
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&h=300&fit=crop',
    'flan':
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=300&fit=crop',
    'banner_promo':
        'https://images.unsplash.com/photo-1565958011504-4b597dbfa461?w=600&h=300&fit=crop',
  };

  /// Obtiene la ruta de la imagen (local primero, luego URL)
  static String? getLocalImagePath(String productName) {
    final key = productName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    return localImages[key];
  }

  /// Obtiene la URL de la imagen basada en el nombre del producto
  static String getImageUrl(String productName) {
    final key = productName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    return placeholderImages[key] ?? placeholderImages['pizza_margherita']!;
  }

  /// Widget que carga imágenes (local primero, luego network)
  static Widget loadImage(
    String productName, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final localPath = getLocalImagePath(productName);

    // Si existe imagen local, usarla
    if (localPath != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          localPath,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Si falla local, intentar con red
            return loadNetworkImage(
              getImageUrl(productName),
              height: height,
              width: width,
              fit: fit,
              borderRadius: borderRadius,
            );
          },
        ),
      );
    }

    // Si no existe local, usar red
    return loadNetworkImage(
      getImageUrl(productName),
      height: height,
      width: width,
      fit: fit,
      borderRadius: borderRadius,
    );
  }

  /// Carga imagen desde red con manejo de errores
  static Widget loadNetworkImage(
    String imageUrl, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: AppTheme.lightGrey,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppTheme.primaryGreen,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppTheme.accentCream,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 40,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(height: 8),
                Text(
                  'Imagen no disponible',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget simplificado para placeholders de colores
  static Widget colorPlaceholder(
    String category, {
    double? height,
    double? width,
    BorderRadius? borderRadius,
  }) {
    final colors = {
      'Pizzas': const Color(0xFFFFD54F),
      'Pastas': const Color(0xFFFFB74D),
      'Bebidas': const Color(0xFF81C784),
      'Postres': const Color(0xFFF48FB1),
    };

    final color = colors[category] ?? AppTheme.accentCream;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            _getCategoryIcon(category),
            size: 50,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Pizzas':
        return Icons.local_pizza;
      case 'Pastas':
        return Icons.restaurant;
      case 'Bebidas':
        return Icons.local_drink;
      case 'Postres':
        return Icons.cake;
      default:
        return Icons.fastfood;
    }
  }
}

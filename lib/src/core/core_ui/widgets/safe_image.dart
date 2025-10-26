import 'package:flutter/material.dart';

/// Widget seguro para cargar imágenes con fallback automático
class SafeImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SafeImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback placeholder cuando la imagen no existe
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withAlpha((0.12 * 255).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_pizza, size: 48, color: Theme.of(context).colorScheme.onSurface.withAlpha((0.5 * 255).round())),
              const SizedBox(height: 8),
              Text(
                'Pizza',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()), fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

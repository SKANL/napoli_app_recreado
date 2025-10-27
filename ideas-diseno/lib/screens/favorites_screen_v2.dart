import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/models/product.dart';

class FavoritesScreenV2 extends StatefulWidget {
  const FavoritesScreenV2({super.key});

  @override
  State<FavoritesScreenV2> createState() => _FavoritesScreenV2State();
}

class _FavoritesScreenV2State extends State<FavoritesScreenV2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Product> _favorites = [
    sampleProducts[0],
    sampleProducts[2],
    sampleProducts[3],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} eliminado de favoritos'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.lightGrey,
        appBar: AppBar(
          title: Text(
            '❤️ Mis Favoritos',
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          leading: const SizedBox.shrink(),
          centerTitle: true,
        ),
        body: _favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 80,
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No hay favoritos aún',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Agrega tus platos favoritos',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppTheme.darkGrey.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppTheme.spacingM,
                    crossAxisSpacing: AppTheme.spacingM,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ProductCardV2(
                          product: _favorites[index],
                          isHorizontal: false,
                        ),
                        // Botón para eliminar de favoritos
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _toggleFavorite(_favorites[index]),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSmall,
                                ),
                                boxShadow: [AppTheme.shadowMedium],
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}

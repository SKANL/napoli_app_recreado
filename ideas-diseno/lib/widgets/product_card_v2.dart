import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/screens/product_detail_screen_v2.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/custom_widgets.dart';

class ProductCardV2 extends StatefulWidget {
  final Product product;
  final bool isHorizontal;

  const ProductCardV2({
    super.key,
    required this.product,
    this.isHorizontal = true,
  });

  @override
  State<ProductCardV2> createState() => _ProductCardV2State();
}

class _ProductCardV2State extends State<ProductCardV2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreenV2(product: widget.product),
            ),
          );
        },
        child: ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.05).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Container(
            width: widget.isHorizontal ? 280 : double.infinity,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                  blurRadius: _isHovered ? 16 : 12,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen con overlay
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E6D3),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppTheme.radiusLarge),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconForCategory(widget.product.category),
                          size: 80,
                          color: const Color(0xFF3D2817).withOpacity(0.3),
                        ),
                      ),
                    ),
                    // Badge de categoría
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Text(
                          widget.product.category,
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Rating (simulado)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall),
                          boxShadow: [AppTheme.shadowSmall],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.product.name,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            widget.product.description,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: AppTheme.darkGrey,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Precio y botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceTag(
                                price: widget.product.price, isLarge: false),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${widget.product.name} agregado'),
                                    backgroundColor: AppTheme.primaryGreen,
                                    duration: const Duration(milliseconds: 800),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [AppTheme.shadowSmall],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'pizzas':
        return Icons.local_pizza_outlined;
      case 'pastas':
        return Icons.restaurant_menu;
      case 'postres':
        return Icons.cake;
      case 'bebidas':
        return Icons.local_drink_outlined;
      default:
        return Icons.fastfood;
    }
  }
}

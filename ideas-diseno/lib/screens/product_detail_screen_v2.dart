import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/models/cart_item.dart';
import 'package:barrio_napoli/models/extra.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/custom_widgets.dart';

class ProductDetailScreenV2 extends StatefulWidget {
  final Product product;

  const ProductDetailScreenV2({super.key, required this.product});

  @override
  State<ProductDetailScreenV2> createState() => _ProductDetailScreenV2State();
}

class _ProductDetailScreenV2State extends State<ProductDetailScreenV2>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  final List<Extra> _selectedExtras = [];
  final TextEditingController _instructionsController = TextEditingController();
  late AnimationController _animationController;

  double get _totalPrice {
    double extrasTotal =
        _selectedExtras.fold(0, (sum, extra) => sum + extra.price);
    return (widget.product.price + extrasTotal) * _quantity;
  }

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
    _instructionsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final cartItem = CartItem(
      product: widget.product,
      quantity: _quantity,
      selectedExtras: List.from(_selectedExtras),
      specialInstructions: _instructionsController.text.isEmpty
          ? null
          : _instructionsController.text,
    );

    Provider.of<CartProvider>(context, listen: false).addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              '${widget.product.name} agregado al carrito',
              style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
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
        body: CustomScrollView(
          slivers: [
            // AppBar con imagen
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 2,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen del producto
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFF5E6D3),
                            const Color(0xFFFFF7F2),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconForCategory(widget.product.category),
                          size: 150,
                          color: const Color(0xFF3D2817).withOpacity(0.2),
                        ),
                      ),
                    ),
                    // Gradiente oscuro en la parte inferior
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    // Badge de categoría
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                        ),
                        child: Text(
                          widget.product.category,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Rating
                    Positioned(
                      top: 60,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                          boxShadow: [AppTheme.shadowMedium],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenido
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y descripción
                    Text(
                      widget.product.name,
                      style: GoogleFonts.roboto(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: AppTheme.darkGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Especificaciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SpecInfo(
                          icon: Icons.local_fire_department,
                          label: 'Calorías',
                          value: '350',
                        ),
                        _SpecInfo(
                          icon: Icons.scale,
                          label: 'Peso',
                          value: '400g',
                        ),
                        _SpecInfo(
                          icon: Icons.timer,
                          label: 'Prep.',
                          value: '15 min',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cantidad
                    Row(
                      children: [
                        Text(
                          'Cantidad:',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.mediumGrey,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                                icon: const Icon(Icons.remove),
                                color: AppTheme.primaryGreen,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity++),
                                icon: const Icon(Icons.add),
                                color: AppTheme.primaryGreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Extras
            if (widget.product.availableExtras.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingM,
                  ),
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [AppTheme.shadowSmall],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar a tu orden',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: widget.product.availableExtras
                            .map(
                              (extra) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _selectedExtras.contains(extra),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedExtras.add(extra);
                                          } else {
                                            _selectedExtras.remove(extra);
                                          }
                                        });
                                      },
                                      activeColor: AppTheme.primaryGreen,
                                    ),
                                    Expanded(
                                      child: Text(
                                        extra.name,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+\$${extra.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

            // Instrucciones especiales
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: [AppTheme.shadowSmall],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instrucciones especiales',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Ej: Sin cebolla, extra queso...',
                      controller: _instructionsController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Precio total y botón
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(AppTheme.spacingL),
                margin: const EdgeInsets.only(top: AppTheme.spacingM),
                child: Column(
                  children: [
                    // Resumen de precio
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGrey,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón de agregar
                    CustomButton(
                      label: 'Agregar al Carrito',
                      onPressed: _addToCart,
                      icon: Icons.shopping_cart,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingL),
            ),
          ],
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

class _SpecInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.accentCream,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppTheme.darkGrey,
          ),
        ),
      ],
    );
  }
}

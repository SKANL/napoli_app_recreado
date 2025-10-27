import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/models/cart_item.dart';
import 'package:barrio_napoli/models/extra.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final List<Extra> _selectedExtras = [];
  final TextEditingController _instructionsController = TextEditingController();

  double get _totalPrice {
    double extrasTotal =
        _selectedExtras.fold(0, (sum, extra) => sum + extra.price);
    return (widget.product.price + extrasTotal) * _quantity;
  }

  @override
  void dispose() {
    _instructionsController.dispose();
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
        content: Text(
          'Añadido al carrito',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF1B5E20),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                    color: const Color(0xFF1B5E20).withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\${widget.product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB53229),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Cantidad',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFFB53229),
                        iconSize: 32,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFFB53229),
                        iconSize: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (widget.product.availableExtras.isNotEmpty) ...[
                    Text(
                      'Personaliza tu pedido',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.product.availableExtras.map((extra) {
                      final isSelected = _selectedExtras.contains(extra);
                      return CheckboxListTile(
                        title: Text(
                          extra.name,
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                        subtitle: Text(
                          '+\${extra.price.toStringAsFixed(2)}',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFFB53229),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: isSelected,
                        activeColor: const Color(0xFF1B5E20),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedExtras.add(extra);
                            } else {
                              _selectedExtras.remove(extra);
                            }
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    'Instrucciones especiales',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _instructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Ej: Sin cebolla, bien cocida, etc.',
                        hintStyle:
                            GoogleFonts.roboto(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB53229),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Añadir al carrito',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '\${_totalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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

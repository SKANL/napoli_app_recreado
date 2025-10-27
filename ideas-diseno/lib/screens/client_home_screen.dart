import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/widgets/pizza_card.dart';
import 'package:barrio_napoli/widgets/menu_list_item.dart';
import 'package:badges/badges.dart' as badges;
import 'package:barrio_napoli/widgets/category_chip.dart';
import 'package:barrio_napoli/screens/cart_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Todos',
    'Pizzas',
    'Pastas',
    'Bebidas',
    'Postres'
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') {
      return sampleProducts;
    }
    return sampleProducts
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 2,
            title: Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFB53229), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entregar en',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Calle Principal 123',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B5E20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return badges.Badge(
                    badgeContent: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    showBadge: cart.itemCount > 0,
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Color(0xFFB53229),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart,
                          color: Color(0xFF1B5E20)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartScreen()));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar pizzas, pastas...',
                    hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF1B5E20)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFB53229),
                            const Color(0xFFD93025),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_offer,
                                size: 50, color: Colors.white),
                            const SizedBox(height: 12),
                            Text(
                              '¡Ofertas Especiales!',
                              style: GoogleFonts.anton(),
                            ),
                            Text(
                              '2x1 en pizzas seleccionadas',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
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
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(top: 24, bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: _categories[index],
                    isSelected: _selectedCategory == _categories[index],
                    onTap: () {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Recomendaciones para ti',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredProducts.take(3).length,
                itemBuilder: (context, index) {
                  return PizzaCard(product: _filteredProducts[index]);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Menú Completo',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MenuListItem(product: _filteredProducts[index]);
              },
              childCount: _filteredProducts.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

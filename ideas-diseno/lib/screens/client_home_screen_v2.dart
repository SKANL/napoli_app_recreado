import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/screens/cart_screen.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/category_chip.dart';
import 'package:barrio_napoli/widgets/menu_list_item.dart';

class ClientHomeScreenV2 extends StatefulWidget {
  const ClientHomeScreenV2({super.key});

  @override
  State<ClientHomeScreenV2> createState() => _ClientHomeScreenV2State();
}

class _ClientHomeScreenV2State extends State<ClientHomeScreenV2>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  final List<String> _categories = [
    'Todos',
    'Pizzas',
    'Pastas',
    'Bebidas',
    'Postres'
  ];

  List<Product> get _filteredProducts {
    var filtered = sampleProducts;

    if (_selectedCategory != 'Todos') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
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
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F2),
        body: CustomScrollView(
          slivers: [
            // AppBar mejorado
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: const Color(0xFFF5E6D3),
              elevation: 2,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromRGBO(0, 106, 78, 1),
                        AppTheme.primaryGreen,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingM,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Entregar en',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    'Calle Principal 123',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
              ),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: badges.Badge(
                        badgeContent: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        showBadge: cart.itemCount > 0,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppTheme.primaryRed,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_bag,
                            color: Color.fromARGB(255, 3, 70, 52),
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Buscador
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [AppTheme.shadowMedium],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Buscar pizzas, pastas...',
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF3D2817)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close,
                                  color: Color(0xFF3D2817)),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),

            // Banner promocional hermoso
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [AppTheme.shadowMedium],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Imagen de fondo
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
                        ),
                        // Overlay gradiente oscuro
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF3D2817).withOpacity(0.4),
                                const Color(0xFFD93025).withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                        // Contenido
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_offer,
                                  size: 40,
                                  color: Color(0xFFD93025),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '¡Ofertas Especiales!',
                                style: GoogleFonts.anton(
                                  fontSize: 28,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2x1 en pizzas seleccionadas',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Filtro de categorías mejorado
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(
                  top: AppTheme.spacingL,
                  bottom: AppTheme.spacingM,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: AppTheme.spacingS,
                      ),
                      child: CategoryChip(
                        label: _categories[index],
                        isSelected: _selectedCategory == _categories[index],
                        onTap: () {
                          setState(() {
                            _selectedCategory = _categories[index];
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Sección "Recomendaciones"
            if (_searchController.text.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  child: Text(
                    '⭐ Recomendaciones para ti',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),

            // Grid de productos recomendados
            if (_searchController.text.isEmpty &&
                _filteredProducts.take(3).isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  child: SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                      ),
                      itemCount: _filteredProducts.take(3).length,
                      itemBuilder: (context, index) {
                        return ProductCardV2(
                          product: _filteredProducts[index],
                          isHorizontal: true,
                        );
                      },
                    ),
                  ),
                ),
              ),

            // Sección "Menú Completo"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingM,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                  AppTheme.spacingS,
                ),
                child: Text(
                  '📋 Menú Completo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            // Lista de productos
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    child: MenuListItem(product: _filteredProducts[index]),
                  );
                },
                childCount: _filteredProducts.length,
              ),
            ),

            // Espacio al final
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXL),
            ),
          ],
        ),
      ),
    );
  }
}

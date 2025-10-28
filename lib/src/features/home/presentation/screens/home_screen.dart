import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'dart:math' as math;
import 'package:napoli_app_v1/src/core/core_ui/widgets/product_card.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/product_list_item.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/header.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/footer.dart';
import 'package:napoli_app_v1/src/features/detail/presentation/screens/detail_screen.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _bannerController;
  late final Animation<double> _bannerAnim;

  final List<String> _categories = [
    'Todos',
    'Pizzas',
    'Pastas',
    'Bebidas',
    'Postres',
  ];

  List<Product> _filterByCategory(List<Product> items) {
    if (_selectedCategory == 'Todos') return items;
    return items.where((p) => p.category == _selectedCategory).toList();
  }

  List<Product> _applyFilters(List<Product> items) {
    // filter by category
    var filtered = _filterByCategory(items);
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return filtered;
    return filtered.where((p) {
      final name = p.name.toLowerCase();
      final cat = p.category.toLowerCase();
      return name.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  _bannerController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
    _bannerAnim = CurvedAnimation(parent: _bannerController, curve: Curves.easeInOut);
    // listen to search changes to update UI
    _searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 0.98, end: 1.02).animate(CurvedAnimation(parent: _bannerController, curve: Curves.easeInOut)),
        child: AppFooter(onCartTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
        }),
      ),
      body: CustomScrollView(
        slivers: [
          // Keep the app header (address) as a top element aligned with existing widgets
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: const AppHeader(address: 'Ciudad de México, México'),
            ),
          ),

          // Search field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: theme.shadowColor.withAlpha((0.06 * 255).round()), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar pizzas, pastas...'.toUpperCase(),
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ),

          // Promo banner
          // Animated promo banner: subtle horizontal slide and pulse
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AnimatedBuilder(
                animation: _bannerAnim,
                builder: (context, child) {
                  final dx = math.sin(_bannerAnim.value * math.pi * 2) * 6; // small slide
                  final opacity = 0.9 + 0.1 * _bannerAnim.value;
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withAlpha((0.12 * 255).round()),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Container(
                      decoration: const BoxDecoration(
                        // Gradiente cálido de pizzería: naranja fuego → rojo CTA
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.fireOrange,
                            AppColors.primaryRed,
                            AppColors.toastedRed,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_offer, size: 44, color: AppColors.white),
                            const SizedBox(height: 10),
                            Text(
                              'OFERTAS ESPECIALES',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black.withAlpha((0.3 * 255).round()),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '2x1 en pizzas seleccionadas',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.white,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black.withAlpha((0.25 * 255).round()),
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
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
              ),
            ),
          ),

          // Categories horizontal
          SliverToBoxAdapter(
            child: SizedBox(
              height: 64,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = _categories[index];
                  final selected = label == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (selected) BoxShadow(color: theme.shadowColor.withAlpha((0.06 * 255).round()), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(color: selected ? AppColors.white : theme.colorScheme.onSurface, fontWeight: FontWeight.w600),
                        child: Text(label),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Recommendations title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Recomendaciones para ti', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            ),
          ),

          // Horizontal featured products
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: FutureBuilder<List<Product>>(
                future: productsRepository.fetchFeatured(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    // show horizontal placeholders
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha((0.04 * 255).round()), blurRadius: 6, offset: const Offset(0, 3))],
                        ),
                      ),
                    );
                  }
                  final items = _applyFilters(snapshot.data ?? []);
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final p = items[index];
                      // staggered entrance using TweenAnimationBuilder (opacity + translate)
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 380 + (index * 70)),
                        builder: (context, val, child) {
                          return Opacity(
                            opacity: val,
                            child: Transform.translate(
                              offset: Offset(0, (1 - val) * 12),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PressableScale(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id))),
                              child: ProductCard(title: p.name, category: p.category, price: '\$${p.price}', imagePath: p.image, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id)))),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Menu title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Menú Completo', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            ),
          ),

          // Full menu list
          FutureBuilder<List<Product>>(
            future: productsRepository.fetchBusinessLunch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                // show sliver list placeholders while loading
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        height: 88,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    childCount: 6,
                  ),
                );
              }
              final all = _applyFilters(snapshot.data ?? []);
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final p = all[index];
                    return ProductListItem(
                      imagePath: p.image,
                      title: p.name,
                      subtitle: p.category,
                      price: '\$${p.price} MXN',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id))),
                    );
                  },
                  childCount: all.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

/// Small helper for tactile press animation (scale down on press)
class PressableScale extends StatefulWidget {
  final Widget child;
  final double downScale;
  const PressableScale({required this.child, this.downScale = 0.96, super.key});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  double _scale = 1.0;

  void _down([TapDownDetails? _]) => setState(() => _scale = widget.downScale);
  void _up([dynamic _]) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _up,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

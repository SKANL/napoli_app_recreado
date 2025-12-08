import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'dart:math' as math;
import 'package:napoli_app_v1/src/core/core_ui/widgets/product_card.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/product_list_item.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/header.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/footer.dart';
import 'package:napoli_app_v1/src/features/detail/presentation/screens/detail_screen.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napoli_app_v1/src/features/products/presentation/cubit/products_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:napoli_app_v1/src/features/products/presentation/cubit/products_state.dart';
import 'package:napoli_app_v1/src/features/products/presentation/cubit/products_state.dart';
import 'package:napoli_app_v1/src/core/error/failures.dart';
import 'package:napoli_app_v1/src/features/home/presentation/cubit/business_status_cubit.dart';
import 'package:napoli_app_v1/src/features/home/presentation/cubit/business_status_state.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/business_closed_dialog.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/closing_soon_dialog.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/pressable_scale.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _bannerController;
  late final Animation<double> _bannerAnim;

  final List<String> _internalCategories = [
    'Todos',
    'Pizzas',
    'Pastas',
    'Bebidas',
    'Postres',
  ];

  String _getCategoryDisplayName(String internal, AppLocalizations l10n) {
    switch (internal) {
      case 'Todos':
        return l10n.catAll;
      case 'Pizzas':
        return l10n.catPizzas;
      case 'Pastas':
        return l10n.catPastas;
      case 'Bebidas':
        return l10n.catDrinks;
      case 'Postres':
        return l10n.catDesserts;
      default:
        return internal;
    }
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
    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _bannerAnim = CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeInOut,
    );
    // listen to search changes to update UI
    _searchController.addListener(() {
      context.read<ProductsCubit>().filterProducts(
        query: _searchController.text,
      );
    });

    // Mostrar diálogo de horarios al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessStatusCubit>().checkBusinessStatus();
      getIt<ProductsCubit>().loadHomeProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 0.98, end: 1.02).animate(
          CurvedAnimation(parent: _bannerController, curve: Curves.easeInOut),
        ),
        child: AppFooter(
          onCartTap: () {
            context.push('/cart');
          },
        ),
      ),
      body: BlocProvider.value(
        value: getIt<ProductsCubit>(),
        child: BlocListener<BusinessStatusCubit, BusinessStatusState>(
          listener: (context, state) {
            if (state is BusinessClosed) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BusinessClosedDialog(
                  nextOpeningTime: state.nextOpeningTime,
                  schedule: state.schedule,
                ),
              );
            } else if (state is BusinessClosingSoon) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const ClosingSoonDialog(),
              );
            }
          },
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductsError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is HomeProductsLoaded) {
                return CustomScrollView(
                  slivers: [
                    // Keep the app header (address) as a top element aligned with existing widgets
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: AppHeader(address: l10n.homeAddress),
                      ),
                    ),

                    // Search field
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withAlpha(
                                  (0.06 * 255).round(),
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: l10n.searchHint,
                              prefixIcon: Icon(
                                Icons.search,
                                color: theme.colorScheme.primary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Promo banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: AnimatedBuilder(
                          animation: _bannerAnim,
                          builder: (context, child) {
                            final dx =
                                math.sin(_bannerAnim.value * math.pi * 2) *
                                6; // small slide
                            final opacity = 0.9 + 0.1 * _bannerAnim.value;
                            return Transform.translate(
                              offset: Offset(dx, 0),
                              child: Opacity(opacity: opacity, child: child),
                            );
                          },
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withAlpha(
                                    (0.12 * 255).round(),
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
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
                                      Image.asset(
                                        'assets/icons/etiqueta.png',
                                        width: 44,
                                        height: 44,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        l10n.specialOffers,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w800,
                                              shadows: [
                                                Shadow(
                                                  color: AppColors.black
                                                      .withAlpha(
                                                        (0.3 * 255).round(),
                                                      ),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        l10n.specialOfferDesc,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: AppColors.white,
                                              shadows: [
                                                Shadow(
                                                  color: AppColors.black
                                                      .withAlpha(
                                                        (0.25 * 255).round(),
                                                      ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: _internalCategories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final internalCat = _internalCategories[index];
                            final label = _getCategoryDisplayName(
                              internalCat,
                              l10n,
                            );
                            final selected =
                                internalCat == state.selectedCategory;
                            return GestureDetector(
                              onTap: () => context
                                  .read<ProductsCubit>()
                                  .filterProducts(category: internalCat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    if (selected)
                                      BoxShadow(
                                        color: theme.shadowColor.withAlpha(
                                          (0.06 * 255).round(),
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                  ],
                                ),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 220),
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.white
                                        : theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          l10n.recommendations,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                    // Horizontal featured products
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Builder(
                          builder: (context) {
                            final items = state.filteredFeatured;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final p = items[index];
                                // staggered entrance using TweenAnimationBuilder (opacity + translate)
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: Duration(
                                    milliseconds: 380 + (index * 70),
                                  ),
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
                                        onTap: () =>
                                            context.push('/product/${p.id}'),
                                        child: ProductCard(
                                          title: p.name,
                                          category: p.category,
                                          price: '\$${p.price}',
                                          imagePath: p.image,
                                          onTap: () =>
                                              context.push('/product/${p.id}'),
                                        ),
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
                        child: Text(
                          l10n.fullMenu,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                    // Full menu list
                    Builder(
                      builder: (context) {
                        final all = state.filteredBusinessLunch;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = all[index];
                            return ProductListItem(
                              imagePath: p.image,
                              title: p.name,
                              subtitle: p.category,
                              price: '\$${p.price} MXN',
                              onTap: () => context.push('/product/${p.id}'),
                            );
                          }, childCount: all.length),
                        );
                      },
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

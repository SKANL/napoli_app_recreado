import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/safe_image.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:napoli_app_v1/src/features/products/presentation/cubit/product_detail_cubit.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';
import 'package:napoli_app_v1/src/features/cart/domain/entities/cart_item.dart';

class DetailScreen extends StatefulWidget {
  final int? index; // kept for compatibility
  final String? productId;
  const DetailScreen({super.key, this.index, this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  final List<ProductExtra> _selectedExtras = [];
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  int _calculateTotalPrice(Product product) {
    int extrasTotal = _selectedExtras.fold(
      0,
      (sum, extra) => sum + extra.price,
    );
    return (product.price + extrasTotal) * _quantity;
  }

  void _addToCart(Product product) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<CartCubit>().addItem(
      CartItem(
        id: id,
        name: product.name,
        image: product.image,
        price: product.price,
        quantity: _quantity,
        selectedExtras: List.from(_selectedExtras),
        specialInstructions: _instructionsController.text.isEmpty
            ? null
            : _instructionsController.text,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.addedToCart,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider(
          create: (context) {
            final cubit = getIt<ProductDetailCubit>();
            if (widget.productId != null) {
              cubit.loadProduct(widget.productId!);
            }
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProductDetailError) {
            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: Center(child: Text('Error: ${state.message}')),
            );
          } else if (state is ProductDetailLoaded) {
            final product = state.product;
            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: theme.colorScheme.primary,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: theme.colorScheme.surface.withAlpha(
                          (0.85 * 255).round(),
                        ),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.colorScheme.onSurface,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.accentBeigeLight,
                              AppColors.surfaceLight,
                            ],
                          ),
                        ),
                        child: Center(
                          child: product.image.isNotEmpty
                              ? SafeImage(
                                  assetPath: product.image,
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  _getIconForCategory(product.category),
                                  size: 150,
                                  color: theme.colorScheme.primary.withAlpha(
                                    (0.2 * 255).round(),
                                  ),
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
                            product.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.7 * 255).round(),
                              ),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '\$${product.price} MXN',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            l10n.quantity,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
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
                                color: AppColors.primaryRed,
                                iconSize: 32,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: theme.dividerColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$_quantity',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity++),
                                icon: const Icon(Icons.add_circle_outline),
                                color: AppColors.primaryRed,
                                iconSize: 32,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (product.availableExtras.isNotEmpty) ...[
                            Text(
                              l10n.customizeOrder,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...product.availableExtras.map((extra) {
                              final isSelected = _selectedExtras.contains(
                                extra,
                              );
                              return CheckboxListTile(
                                title: Text(
                                  extra.name,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  '+\$${extra.price} MXN',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: isSelected,
                                activeColor: theme.colorScheme.primary,
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
                            l10n.specialInstructions,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _instructionsController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: l10n.specialInstructionsHint,
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    (0.4 * 255).round(),
                                  ),
                                ),
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
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha((0.1 * 255).round()),
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
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.addToCart,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '\$${_calculateTotalPrice(product)} MXN',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
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
          // Default case (Initial or null product)
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: Center(child: Text(l10n.productNotFound)),
          );
        },
      ),
    );
  }
}

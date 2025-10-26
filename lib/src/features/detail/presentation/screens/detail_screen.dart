import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/size_selector.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/quantity_selector.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/safe_image.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/services/cart.service.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';

class DetailScreen extends StatefulWidget {
  final int? index; // kept for compatibility
  final String? productId;
  const DetailScreen({super.key, this.index, this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.productId != null
        ? productsRepository.getById(widget.productId!)
        : Future.value(
            Product(
              id: 'p0',
              name: 'Pizza Name',
              category: 'Category',
              price: 199,
              image: 'assets/images/flamenco-waiting.png',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: FutureBuilder<Product?>(
        future: _productFuture,
        builder: (context, snapshot) {
          final product = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.cancel, color: Colors.red),
                    // ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    height: 240,
                    child: SafeImage(
                      assetPath:
                          product?.image ??
                          'assets/images/flamenco-waiting.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? 'Pizza Name',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\u2605 4.5',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product?.price ?? 199} MXN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      // Use the theme's card color so this area adapts to light/dark
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withAlpha((Theme.of(context).brightness == Brightness.dark ? (0.22 * 255) : (0.12 * 255)).round()),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const SizeSelector(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cheese',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                            const QuantitySelector(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Onion',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                            const QuantitySelector(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final navigator = Navigator.of(context);
          final product = await _productFuture;
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          cartService.addItem(
            CartItem(
              id: id,
              name: product?.name ?? 'Pizza',
              image: product?.image ?? 'assets/images/flamenco-waiting.png',
              price: product?.price ?? 199,
              size: 'M',
            ),
          );
          if (!mounted) return;
          navigator.push(MaterialPageRoute(builder: (_) => const CartScreen()));
        },
        label: const Text('Add to Cart'),
      ),
    );
  }
}

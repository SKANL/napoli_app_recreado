import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/product_card.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/header.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/footer.dart';
import 'package:napoli_app_v1/src/features/detail/presentation/screens/detail_screen.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: AppFooter(onCartTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
      }),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(address: 'Ciudad de México, México'),
            const SizedBox(height: 12),
            const Text('What would you like to eat?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<Product>>(
                future: productsRepository.fetchFeatured(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id))),
                        child: ProductCard(title: p.name, category: p.category, price: '\$${p.price}', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id)))),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Business Lunch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: productsRepository.fetchBusinessLunch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return ListTile(
                        leading: const CircleAvatar(child: FlutterLogo()),
                        title: Text(p.name),
                        subtitle: Text(p.category),
                        trailing: Text('\$${p.price} MXN'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(productId: p.id))),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

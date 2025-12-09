import 'package:flutter/material.dart';

import 'package:napoli_app_v1/src/features/settings/domain/entities/order_history.dart';

class FavoriteProductsList extends StatelessWidget {
  final List<OrderHistory> orders;

  const FavoriteProductsList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calcular productos más frecuentes
    final productCount = <String, int>{};
    for (final order in orders) {
      if (order.status == OrderHistoryStatus.delivered) {
        for (final item in order.items) {
          productCount[item.name] =
              (productCount[item.name] ?? 0) + item.quantity;
        }
      }
    }

    final sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedProducts.isEmpty) {
      return Center(
        child: Text(
          'No has realizado pedidos entregados aún.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    // Tomar top 5
    final topProducts = sortedProducts.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tus productos favoritos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...topProducts.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_pizza,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Pedido ${entry.value} veces',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      // TODO: Add to cart logic
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'core/services/cart.service.dart';
import 'features/products/data/mock_product_repository.dart';
import 'core/core_domain/repositories/product_repository.dart';

// Minimal DI placeholder for UI-only scaffold
// In full architecture this would register modules and providers
void initDi() {
  // Intentionally empty for UI scaffold
}

// Simple singletons for UI-only app
final CartService cartService = CartService();
final ProductRepository productsRepository = MockProductRepository();

import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';
import 'package:napoli_app_v1/src/core/core_domain/repositories/product_repository.dart';

class MockProductRepository implements ProductRepository {
  final List<Product> _products = List.generate(
    6,
    (i) => Product(
      id: 'p$i',
      name: 'Pizza #$i',
      category: i % 2 == 0 ? 'Veg' : 'Non-Veg',
      price: 99 + i * 20,
      image: 'assets/images/flamenco-waiting.png',
    ),
  );

  @override
  Future<List<Product>> fetchFeatured() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _products;
  }

  @override
  Future<List<Product>> fetchBusinessLunch() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _products.reversed.toList();
  }

  @override
  Future<Product?> getById(String id) async {
    return _products.firstWhere((p) => p.id == id, orElse: () => _products.first);
  }
}

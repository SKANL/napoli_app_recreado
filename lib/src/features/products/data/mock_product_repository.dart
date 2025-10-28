import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';
import 'package:napoli_app_v1/src/core/core_domain/repositories/product_repository.dart';

class MockProductRepository implements ProductRepository {
  final List<Product> _products = [
    Product(id: 'p1', name: 'Margherita', category: 'Pizzas', price: 120, image: 'assets/image-products/pizza.png'),
    Product(id: 'p2', name: 'Pepperoni', category: 'Pizzas', price: 150, image: 'assets/image-products/pizza.png'),
    Product(id: 'p3', name: 'Carbonara', category: 'Pastas', price: 130, image: 'assets/image-products/pasta.png'),
    Product(id: 'p4', name: 'Fettuccine', category: 'Pastas', price: 140, image: 'assets/image-products/pasta.png'),
    Product(id: 'p5', name: 'Limonada', category: 'Bebidas', price: 40, image: 'assets/image-products/drink.png'),
    Product(id: 'p6', name: 'Tiramisú', category: 'Postres', price: 70, image: 'assets/image-products/dessert.png'),
    Product(id: 'p7', name: 'Hawaiana', category: 'Pizzas', price: 155, image: 'assets/image-products/pizza.png'),
    Product(id: 'p8', name: 'Agua Mineral', category: 'Bebidas', price: 30, image: 'assets/image-products/drink.png'),
  ];

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

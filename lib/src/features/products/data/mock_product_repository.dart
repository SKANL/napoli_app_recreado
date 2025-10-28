import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';
import 'package:napoli_app_v1/src/core/core_domain/repositories/product_repository.dart';

class MockProductRepository implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Margherita',
      category: 'Pizzas',
      price: 120,
      image: 'assets/image-products/pizza.png',
      description: 'Base salsa de tomate San Marzano, mozzarella fior di latte, parmesano, albahaca fresca. Completada con sabor napolitano contemporáneo.',
      availableExtras: [
        ProductExtra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtra(id: 'e2', name: 'Albahaca Extra', price: 15),
        ProductExtra(id: 'e3', name: 'Aceitunas', price: 20),
      ],
    ),
    Product(
      id: 'p2',
      name: 'Pepperoni',
      category: 'Pizzas',
      price: 150,
      image: 'assets/image-products/pizza.png',
      description: 'Salsa de tomate, mozzarella, pepperoni italiano, orégano y un toque de aceite de oliva.',
      availableExtras: [
        ProductExtra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtra(id: 'e4', name: 'Pepperoni Extra', price: 35),
        ProductExtra(id: 'e5', name: 'Jalapeños', price: 15),
      ],
    ),
    Product(
      id: 'p3',
      name: 'Carbonara',
      category: 'Pastas',
      price: 130,
      image: 'assets/image-products/carbonara.png',
      description: 'Pasta fresca con salsa carbonara tradicional, pancetta, huevo y queso parmesano.',
      availableExtras: [],
    ),
    Product(
      id: 'p4',
      name: 'Fettuccine',
      category: 'Pastas',
      price: 140,
      image: 'assets/image-products/fettuccine.png',
      description: 'Fettuccine al dente con salsa cremosa y hierbas finas.',
      availableExtras: [],
    ),
    Product(
      id: 'p5',
      name: 'Limonada',
      category: 'Bebidas',
      price: 40,
      image: 'assets/image-products/limonada.png',
      description: 'Refrescante limonada natural hecha con limones frescos.',
      availableExtras: [],
    ),
    Product(
      id: 'p6',
      name: 'Tiramisú',
      category: 'Postres',
      price: 70,
      image: 'assets/image-products/tiramisu.png',
      description: 'Clásico postre italiano con capas de café, mascarpone y cacao.',
      availableExtras: [],
    ),
    Product(
      id: 'p7',
      name: 'Hawaiana',
      category: 'Pizzas',
      price: 155,
      image: 'assets/image-products/pizza.png',
      description: 'Pizza con jamón, piña, mozzarella y salsa de tomate.',
      availableExtras: [
        ProductExtra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtra(id: 'e6', name: 'Piña Extra', price: 20),
      ],
    ),
    Product(
      id: 'p8',
      name: 'Agua Mineral',
      category: 'Bebidas',
      price: 30,
      image: 'assets/image-products/agua.png',
      description: 'Agua mineral natural de manantial.',
      availableExtras: [],
    ),
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

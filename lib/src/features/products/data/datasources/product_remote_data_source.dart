import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

@LazySingleton(as: ProductRemoteDataSource, env: ['dev'])
class MockProductDataSource implements ProductRemoteDataSource {
  final DioClient _dioClient;

  MockProductDataSource(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    // In a real app: final response = await _dioClient.get('/products');
    // return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();

    // Simulating API latency
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  // Hardcoded data simulating API Response
  final List<ProductModel> _products = [
    ProductModel(
      id: 'p1',
      name: 'Margherita',
      category: 'Pizzas',
      price: 120,
      image: 'assets/image-products/pizza.png',
      description:
          'Base salsa de tomate San Marzano, mozzarella fior di latte, parmesano, albahaca fresca. Completada con sabor napolitano contemporáneo.',
      availableExtras: [
        ProductExtraModel(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtraModel(id: 'e2', name: 'Albahaca Extra', price: 15),
        ProductExtraModel(id: 'e3', name: 'Aceitunas', price: 20),
      ],
    ),
    ProductModel(
      id: 'p2',
      name: 'Pepperoni',
      category: 'Pizzas',
      price: 150,
      image: 'assets/image-products/pizza.png',
      description:
          'Salsa de tomate, mozzarella, pepperoni italiano, orégano y un toque de aceite de oliva.',
      availableExtras: [
        ProductExtraModel(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtraModel(id: 'e4', name: 'Pepperoni Extra', price: 35),
        ProductExtraModel(id: 'e5', name: 'Jalapeños', price: 15),
      ],
    ),
    ProductModel(
      id: 'p3',
      name: 'Carbonara',
      category: 'Pastas',
      price: 130,
      image: 'assets/image-products/carbonara.png',
      description:
          'Pasta fresca con salsa carbonara tradicional, pancetta, huevo y queso parmesano.',
      availableExtras: [],
    ),
    ProductModel(
      id: 'p4',
      name: 'Fettuccine',
      category: 'Pastas',
      price: 140,
      image: 'assets/image-products/fettuccine.png',
      description: 'Fettuccine al dente con salsa cremosa y hierbas finas.',
      availableExtras: [],
    ),
    ProductModel(
      id: 'p5',
      name: 'Limonada',
      category: 'Bebidas',
      price: 40,
      image: 'assets/image-products/limonada.png',
      description: 'Refrescante limonada natural hecha con limones frescos.',
      availableExtras: [],
    ),
    ProductModel(
      id: 'p6',
      name: 'Tiramisú',
      category: 'Postres',
      price: 70,
      image: 'assets/image-products/tiramisu.png',
      description:
          'Clásico postre italiano con capas de café, mascarpone y cacao.',
      availableExtras: [],
    ),
    ProductModel(
      id: 'p7',
      name: 'Hawaiana',
      category: 'Pizzas',
      price: 155,
      image: 'assets/image-products/pizza.png',
      description: 'Pizza con jamón, piña, mozzarella y salsa de tomate.',
      availableExtras: [
        ProductExtraModel(id: 'e1', name: 'Extra Queso Mozzarella', price: 25),
        ProductExtraModel(id: 'e6', name: 'Piña Extra', price: 20),
      ],
    ),
    ProductModel(
      id: 'p8',
      name: 'Agua Mineral',
      category: 'Bebidas',
      price: 30,
      image: 'assets/image-products/agua.png',
      description: 'Agua mineral natural de manantial.',
      availableExtras: [],
    ),
  ];
}

@LazySingleton(as: ProductRemoteDataSource, env: ['prod'])
class RealProductDataSource implements ProductRemoteDataSource {
  final DioClient _dioClient;

  RealProductDataSource(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts() {
    // TODO: implement getProducts with real API
    // return _dioClient.get('/products')...
    throw UnimplementedError();
  }
}

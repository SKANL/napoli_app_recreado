import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchFeatured();
  Future<List<Product>> fetchBusinessLunch();
  Future<Product?> getById(String id);
}

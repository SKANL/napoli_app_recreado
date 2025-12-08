import 'package:fpdart/fpdart.dart';
import '../../error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> fetchFeatured();
  Future<Either<Failure, List<Product>>> fetchBusinessLunch();
  Future<Either<Failure, Product?>> getById(String id);
}

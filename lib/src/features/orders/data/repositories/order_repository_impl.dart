import 'package:fpdart/fpdart.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final models = await _localDataSource.getOrders();
      // Sort by date descending
      models.sort((a, b) => b.date.compareTo(a.date));
      return Right(models);
    } on CacheException {
      return const Left(CacheFailure('Error al cargar los pedidos'));
    }
  }

  @override
  Future<Either<Failure, void>> saveOrder(Order order) async {
    try {
      final model = OrderModel.fromEntity(order);
      await _localDataSource.saveOrder(model);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Error al guardar el pedido'));
    }
  }
}

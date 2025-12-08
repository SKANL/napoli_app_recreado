import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

@lazySingleton
class SaveOrderUseCase implements UseCase<void, SaveOrderParams> {
  final OrderRepository _repository;

  SaveOrderUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveOrderParams params) async {
    return await _repository.saveOrder(params.order);
  }
}

class SaveOrderParams extends Equatable {
  final Order order;

  const SaveOrderParams({required this.order});

  @override
  List<Object?> get props => [order];
}

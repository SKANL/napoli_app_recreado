import 'package:injectable/injectable.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/order_history.dart';
import 'package:napoli_app_v1/src/features/settings/domain/repositories/order_history_repository.dart';

@LazySingleton(as: OrderHistoryRepository, env: ['dev'])
class MockOrderHistoryRepository implements OrderHistoryRepository {
  final List<OrderHistory> _orders = [];

  MockOrderHistoryRepository() {
    _orders.addAll(_generateMockOrders());
  }

  @override
  List<OrderHistory> getOrders() {
    return List.unmodifiable(_orders);
  }

  @override
  void updateOrderRating(String orderId, int rating) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(rating: rating);
    }
  }

  List<OrderHistory> _generateMockOrders() {
    return [
      OrderHistory(
        id: '#ORD-2024-001',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: OrderHistoryStatus.delivered,
        items: const [
          OrderHistoryItem(
            name: 'Pizza Margherita',
            quantity: 1,
            price: 189.00,
          ),
          OrderHistoryItem(name: 'Coca Cola 355ml', quantity: 2, price: 35.00),
        ],
        total: 259.00,
        paymentMethod: 'Visa **** 1234',
        deliveryAddress: 'Calle Revolución 123, Col. Centro',
        deliveryTime: '25-35 min',
        rating: 5,
      ),
      OrderHistory(
        id: '#ORD-2024-002',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderHistoryStatus.delivered,
        items: const [
          OrderHistoryItem(
            name: 'Pizza Pepperoni Familiar',
            quantity: 1,
            price: 299.00,
          ),
          OrderHistoryItem(
            name: 'Alitas BBQ (8 pzs)',
            quantity: 1,
            price: 159.00,
          ),
          OrderHistoryItem(name: 'Refresco 2L', quantity: 1, price: 45.00),
        ],
        total: 503.00,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Av. Universidad 456, Col. Del Valle',
        deliveryTime: '30-40 min',
        rating: 4,
      ),
      OrderHistory(
        id: '#ORD-2024-003',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: OrderHistoryStatus.inProgress,
        items: const [
          OrderHistoryItem(name: 'Pizza Hawaiana', quantity: 2, price: 179.00),
          OrderHistoryItem(name: 'Pan de Ajo', quantity: 1, price: 65.00),
        ],
        total: 423.00,
        paymentMethod: 'Mastercard **** 5678',
        deliveryAddress: 'Calle Morelos 789, Col. Doctores',
        deliveryTime: '20-30 min',
        rating: null,
      ),
      OrderHistory(
        id: '#ORD-2024-004',
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: OrderHistoryStatus.cancelled,
        items: const [
          OrderHistoryItem(name: 'Pizza Suprema', quantity: 1, price: 249.00),
        ],
        total: 249.00,
        paymentMethod: 'Visa **** 1234',
        deliveryAddress: 'Calle Hidalgo 321, Col. Roma Norte',
        deliveryTime: '35-45 min',
        rating: null,
        cancellationReason: 'Cancelado por el cliente',
      ),
      OrderHistory(
        id: '#ORD-2024-005',
        date: DateTime.now().subtract(const Duration(days: 14)),
        status: OrderHistoryStatus.delivered,
        items: const [
          OrderHistoryItem(
            name: 'Pizza Cuatro Quesos',
            quantity: 1,
            price: 219.00,
          ),
          OrderHistoryItem(name: 'Ensalada César', quantity: 1, price: 89.00),
          OrderHistoryItem(
            name: 'Agua Natural 600ml',
            quantity: 2,
            price: 25.00,
          ),
        ],
        total: 333.00,
        paymentMethod: 'Transferencia',
        deliveryAddress: 'Calle Insurgentes 654, Col. Condesa',
        deliveryTime: '25-35 min',
        rating: 5,
      ),
    ];
  }
}

@LazySingleton(as: OrderHistoryRepository, env: ['prod'])
class RealOrderHistoryRepository implements OrderHistoryRepository {
  @override
  List<OrderHistory> getOrders() {
    // TODO: implement getOrders with real API
    throw UnimplementedError();
  }

  @override
  void updateOrderRating(String orderId, int rating) {
    // TODO: implement updateOrderRating with real API
    throw UnimplementedError();
  }
}

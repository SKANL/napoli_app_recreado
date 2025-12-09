import 'package:napoli_app_v1/src/features/settings/domain/entities/order_history.dart';

/// Abstract interface for order history data access.
/// This allows easy switching between mock and real API implementations.
abstract class OrderHistoryRepository {
  /// Returns a list of all orders for the current user.
  List<OrderHistory> getOrders();

  /// Updates the rating for a specific order.
  void updateOrderRating(String orderId, int rating);
}

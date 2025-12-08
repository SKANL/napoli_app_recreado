import 'package:json_annotation/json_annotation.dart';
import 'package:napoli_app_v1/src/features/orders/domain/entities/order.dart';
import 'package:napoli_app_v1/src/features/cart/data/models/cart_item_model.dart';
import 'package:napoli_app_v1/src/features/cart/domain/entities/cart_item.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel extends Order {
  @JsonKey(name: 'items')
  final List<CartItemModel> itemsModel;

  const OrderModel({
    required String id,
    required String userId,
    required this.itemsModel,
    required int total,
    required OrderStatus status,
    required DateTime date,
    required String address,
    required String paymentMethod,
  }) : super(
         id: id,
         userId: userId,
         items: itemsModel,
         total: total,
         status: status,
         date: date,
         address: address,
         paymentMethod: paymentMethod,
       );

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      userId: order.userId,
      itemsModel: order.items.map((e) => CartItemModel.fromEntity(e)).toList(),
      total: order.total,
      status: order.status,
      date: order.date,
      address: order.address,
      paymentMethod: order.paymentMethod,
    );
  }
}

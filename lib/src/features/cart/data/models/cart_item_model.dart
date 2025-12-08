import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item.dart';

import '../../../products/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel extends CartItem {
  @JsonKey(name: 'selectedExtras')
  final List<ProductExtraModel> selectedExtrasModel;

  const CartItemModel({
    required String id,
    required String name,
    required String image,
    required int price,
    int quantity = 1,
    this.selectedExtrasModel = const [],
    String? specialInstructions,
  }) : super(
         id: id,
         name: name,
         image: image,
         price: price,
         quantity: quantity,
         selectedExtras: selectedExtrasModel,
         specialInstructions: specialInstructions,
       );

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      id: item.id,
      name: item.name,
      image: item.image,
      price: item.price,
      quantity: item.quantity,
      selectedExtrasModel: item.selectedExtras
          .map((e) => ProductExtraModel.fromEntity(e))
          .toList(),
      specialInstructions: item.specialInstructions,
    );
  }
}

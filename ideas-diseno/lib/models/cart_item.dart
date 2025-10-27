import 'package:barrio_napoli/models/product.dart';
import 'package:barrio_napoli/models/extra.dart';

class CartItem {
  final Product product;
  int quantity;
  final List<Extra> selectedExtras;
  final String? specialInstructions;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedExtras = const [],
    this.specialInstructions,
  });

  double get totalPrice {
    double extrasTotal =
        selectedExtras.fold(0, (sum, extra) => sum + extra.price);
    return (product.price + extrasTotal) * quantity;
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    List<Extra>? selectedExtras,
    String? specialInstructions,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

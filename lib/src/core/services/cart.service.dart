import 'package:flutter/foundation.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/product.dart';
import 'package:napoli_app_v1/src/core/core_domain/entities/coupon.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  int quantity;
  final List<ProductExtra> selectedExtras;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.selectedExtras = const [],
    this.specialInstructions,
  });

  int get totalPrice {
    int extrasTotal = selectedExtras.fold(0, (sum, extra) => sum + extra.price);
    return (price + extrasTotal) * quantity;
  }

  CartItem copyWith({
    String? id,
    String? name,
    String? image,
    int? price,
    int? quantity,
    List<ProductExtra>? selectedExtras,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

class CartService extends ValueNotifier<List<CartItem>> {
  CartService() : super([]);

  static const int _deliveryFee = 50;
  Coupon? _appliedCoupon;

  void addItem(CartItem item) {
    value = [...value, item];
    notifyListeners();
  }

  void removeItem(String id) {
    value = value.where((e) => e.id != id).toList();
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (index < 0 || index >= value.length) return;
    if (newQuantity <= 0) {
      removeItem(value[index].id);
      return;
    }
    final updated = List<CartItem>.from(value);
    updated[index] = updated[index].copyWith(quantity: newQuantity);
    value = updated;
    notifyListeners();
  }

  void clear() {
    value = [];
    _appliedCoupon = null;
    notifyListeners();
  }

  void applyCoupon(Coupon coupon) {
    _appliedCoupon = coupon;
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  Coupon? get appliedCoupon => _appliedCoupon;

  int get subtotal => value.fold(0, (s, it) => s + it.totalPrice);

  int get deliveryFee => value.isEmpty ? 0 : _deliveryFee;

  int get discount {
    if (_appliedCoupon == null || subtotal == 0) return 0;
    return (subtotal * _appliedCoupon!.discountPercentage / 100).round();
  }

  int get total => subtotal + deliveryFee - discount;
}

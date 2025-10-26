import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final String size;
  final int cheese;
  final int onion;

  CartItem({required this.id, required this.name, required this.image, required this.price, required this.size, this.cheese = 0, this.onion = 0});
}

class CartService extends ValueNotifier<List<CartItem>> {
  CartService(): super([]);

  void addItem(CartItem item) {
    value = [...value, item];
    notifyListeners();
  }

  void removeItem(String id) {
    value = value.where((e) => e.id != id).toList();
    notifyListeners();
  }

  int get total => value.fold(0, (s, it) => s + it.price) + (value.isEmpty ? 0 : 50);
}

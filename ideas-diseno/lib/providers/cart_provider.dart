import 'package:flutter/foundation.dart';
import 'package:barrio_napoli/models/cart_item.dart';
import 'package:barrio_napoli/models/extra.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  // Delivery information
  String _address = 'Calle Principal 123';
  String _addressNumber = '';
  String _addressComplement = '';
  String _phone = '';
  String _specialNotes = '';

  List<CartItem> get items => [..._items];

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal > 0 ? 35.00 : 0.00;

  double get total => subtotal + deliveryFee;

  // Delivery information getters and setters
  String get address => _address;
  String get addressNumber => _addressNumber;
  String get addressComplement => _addressComplement;
  String get phone => _phone;
  String get specialNotes => _specialNotes;

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setAddressNumber(String value) {
    _addressNumber = value;
    notifyListeners();
  }

  void setAddressComplement(String value) {
    _addressComplement = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setSpecialNotes(String value) {
    _specialNotes = value;
    notifyListeners();
  }

  void setDeliveryInfo({
    required String address,
    required String addressNumber,
    String? addressComplement,
    required String phone,
    String? specialNotes,
  }) {
    _address = address;
    _addressNumber = addressNumber;
    _addressComplement = addressComplement ?? '';
    _phone = phone;
    _specialNotes = specialNotes ?? '';
    notifyListeners();
  }

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) =>
        i.product.id == item.product.id &&
        _extrasMatch(i.selectedExtras, item.selectedExtras));

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool _extrasMatch(List<Extra> extras1, List<Extra> extras2) {
    if (extras1.length != extras2.length) return false;
    final ids1 = extras1.map((e) => e.id).toSet();
    final ids2 = extras2.map((e) => e.id).toSet();
    return ids1.containsAll(ids2) && ids2.containsAll(ids1);
  }
}

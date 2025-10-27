import 'package:barrio_napoli/models/cart_item.dart';

class Order {
  final List<CartItem> items;
  String address;
  String addressNumber;
  String? addressComplement;
  String phone;
  String? specialNotes;

  Order({
    required this.items,
    required this.address,
    required this.addressNumber,
    this.addressComplement,
    required this.phone,
    this.specialNotes,
  });

  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    return subtotal > 0 ? 35.00 : 0.00;
  }

  double get total {
    return subtotal + deliveryFee;
  }

  int get estimatedMinutes {
    return 25 + (items.length * 3); // Base 25 min + 3 min por item
  }

  String get estimatedTime {
    return '$estimatedMinutes-${estimatedMinutes + 10} min';
  }

  Order copyWith({
    List<CartItem>? items,
    String? address,
    String? addressNumber,
    String? addressComplement,
    String? phone,
    String? specialNotes,
  }) {
    return Order(
      items: items ?? this.items,
      address: address ?? this.address,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      phone: phone ?? this.phone,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }
}

/// Entidad Coupon para descuentos
class Coupon {
  final String code;
  final int discountPercentage; // porcentaje de descuento (0-100)
  final String description;

  Coupon({
    required this.code,
    required this.discountPercentage,
    required this.description,
  });

  /// Cupones disponibles (mock)
  static Coupon? fromCode(String code) {
    final normalized = code.trim().toUpperCase();
    switch (normalized) {
      case 'PIZZA10':
        return Coupon(
          code: 'PIZZA10',
          discountPercentage: 10,
          description: '10% de descuento',
        );
      case 'SAVE20':
        return Coupon(
          code: 'SAVE20',
          discountPercentage: 20,
          description: '20% de descuento',
        );
      case 'MEGA50':
        return Coupon(
          code: 'MEGA50',
          discountPercentage: 50,
          description: '50% de descuento',
        );
      default:
        return null;
    }
  }
}

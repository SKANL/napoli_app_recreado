import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/coupon_model.dart';

abstract class CouponLocalDataSource {
  Future<CouponModel?> getCoupon(String code);
}

@LazySingleton(as: CouponLocalDataSource)
class CouponLocalDataSourceImpl implements CouponLocalDataSource {
  final List<CouponModel> _coupons = const [
    CouponModel(
      code: 'PIZZA10',
      discountPercentage: 10,
      description: '10% de descuento',
    ),
    CouponModel(
      code: 'SAVE20',
      discountPercentage: 20,
      description: '20% de descuento',
    ),
    CouponModel(
      code: 'MEGA50',
      discountPercentage: 50,
      description: '50% de descuento',
    ),
  ];

  @override
  Future<CouponModel?> getCoupon(String code) async {
    try {
      final normalized = code.trim().toUpperCase();
      return _coupons.cast<CouponModel?>().firstWhere(
        (c) => c?.code == normalized,
        orElse: () => null,
      );
    } catch (e) {
      throw CacheException();
    }
  }
}

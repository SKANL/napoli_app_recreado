import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/repositories/coupon_repository.dart';

@LazySingleton(as: CouponRepository)
class CouponRepositoryImpl implements CouponRepository {
  final LocalStorageService _localStorageService;
  static const String _key = 'coupon_history';

  CouponRepositoryImpl(this._localStorageService);

  @override
  Future<void> saveCoupon(String couponCode) async {
    final history = _localStorageService.getStringList(_key) ?? [];

    // Add new coupon with timestamp
    final couponEntry = jsonEncode({
      'code': couponCode,
      'timestamp': DateTime.now().toIso8601String(),
    });

    history.add(couponEntry);
    await _localStorageService.setStringList(_key, history);
  }

  @override
  Future<Either<Failure, List<Coupon>>> getCoupons() async {
    try {
      final history = _localStorageService.getStringList(_key) ?? [];

      final coupons = history.map((entry) {
        final Map<String, dynamic> decoded = jsonDecode(entry);
        final code = decoded['code'] as String;
        final timestamp = DateTime.parse(decoded['timestamp']);

        // Map code to coupon details (simulated "Database" of coupon definitions)
        return _mapCodeToCoupon(code, timestamp);
      }).toList();

      return Right(coupons);
    } catch (e) {
      return Left(CacheFailure('Error loading coupons'));
    }
  }

  @override
  Future<Either<Failure, Coupon?>> getCoupon(String code) async {
    try {
      final history = _localStorageService.getStringList(_key) ?? [];

      for (final entry in history) {
        final Map<String, dynamic> decoded = jsonDecode(entry);
        if (decoded['code'] == code) {
          final timestamp = DateTime.parse(decoded['timestamp']);
          return Right(_mapCodeToCoupon(code, timestamp));
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error finding coupon'));
    }
  }

  @override
  Future<void> clearHistory() async {
    await _localStorageService.remove(_key);
  }

  @override
  Future<int> getCouponCount() async {
    final history = _localStorageService.getStringList(_key) ?? [];
    return history.length;
  }

  Coupon _mapCodeToCoupon(String code, DateTime timestamp) {
    String description = 'Cupón especial';
    int discount = 0;

    switch (code) {
      case 'PIZZA10':
        description = '10% de descuento';
        discount = 10;
        break;
      case 'SAVE20':
        description = '20% de descuento';
        discount = 20;
        break;
      case 'MEGA50':
        description = '50% de descuento';
        discount = 50;
        break;
    }

    return Coupon(
      code: code,
      discountPercentage: discount,
      description: description,
      receivedDate: timestamp,
    );
  }
}

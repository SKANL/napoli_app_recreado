import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/coupon.dart';

abstract class CouponRepository {
  Future<Either<Failure, Coupon?>> getCoupon(String code);
}

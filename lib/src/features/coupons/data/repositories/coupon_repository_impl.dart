import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/coupon_local_data_source.dart';

@LazySingleton(as: CouponRepository)
class CouponRepositoryImpl implements CouponRepository {
  final CouponLocalDataSource _localDataSource;

  CouponRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Coupon?>> getCoupon(String code) async {
    try {
      final coupon = await _localDataSource.getCoupon(code);
      return Right(coupon);
    } on CacheException {
      return const Left(CacheFailure('Error al buscar el cupón'));
    }
  }
}

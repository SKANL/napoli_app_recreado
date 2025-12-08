import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/coupon.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
class CouponModel extends Coupon {
  const CouponModel({
    required super.code,
    required super.discountPercentage,
    required super.description,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);

  factory CouponModel.fromEntity(Coupon coupon) {
    return CouponModel(
      code: coupon.code,
      discountPercentage: coupon.discountPercentage,
      description: coupon.description,
    );
  }
}

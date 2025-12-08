// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => CouponModel(
  code: json['code'] as String,
  discountPercentage: (json['discountPercentage'] as num).toInt(),
  description: json['description'] as String,
);

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'discountPercentage': instance.discountPercentage,
      'description': instance.description,
    };

import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final String code;
  final int discountPercentage;
  final String description;

  const Coupon({
    required this.code,
    required this.discountPercentage,
    required this.description,
  });

  @override
  List<Object?> get props => [code, discountPercentage, description];
}

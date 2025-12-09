import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

enum PaymentType { card, cash, transfer }

@JsonSerializable()
class PaymentMethodModel {
  final String id;
  final PaymentType type;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardBrand;
  bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardBrand,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;
  final String label;
  final String address;
  final String city;
  final String details;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.details,
    required this.isDefault,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? address,
    String? city,
    String? details,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

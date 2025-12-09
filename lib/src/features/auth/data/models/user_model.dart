import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/address_model.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/payment_method.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address; // Legacy single address field
  final String? photoUrl;
  final List<AddressModel> savedAddresses;
  final List<PaymentMethodModel> savedCards;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.photoUrl,
    this.savedAddresses = const [],
    this.savedCards = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? photoUrl,
    List<AddressModel>? savedAddresses,
    List<PaymentMethodModel>? savedCards,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      savedCards: savedCards ?? this.savedCards,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    address,
    photoUrl,
    savedAddresses,
    savedCards,
  ];
}

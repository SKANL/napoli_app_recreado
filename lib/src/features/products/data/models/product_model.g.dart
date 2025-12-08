// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  price: (json['price'] as num).toInt(),
  image: json['image'] as String,
  description: json['description'] as String? ?? '',
  availableExtras:
      (json['availableExtras'] as List<dynamic>?)
          ?.map((e) => ProductExtraModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ProductModelToJson(
  ProductModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'price': instance.price,
  'image': instance.image,
  'description': instance.description,
  'availableExtras': instance.availableExtras.map((e) => e.toJson()).toList(),
};

ProductExtraModel _$ProductExtraModelFromJson(Map<String, dynamic> json) =>
    ProductExtraModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$ProductExtraModelToJson(ProductExtraModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };

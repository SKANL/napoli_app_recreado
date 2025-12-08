import 'package:json_annotation/json_annotation.dart';
import '../../../../core/core_domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final String image;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: [])
  final List<ProductExtraModel> availableExtras;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    required this.availableExtras,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      image: image,
      description: description,
      availableExtras: availableExtras.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      image: product.image,
      description: product.description,
      availableExtras: product.availableExtras
          .map((e) => ProductExtraModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class ProductExtraModel extends ProductExtra {
  const ProductExtraModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory ProductExtraModel.fromJson(Map<String, dynamic> json) =>
      _$ProductExtraModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductExtraModelToJson(this);

  ProductExtra toEntity() {
    return ProductExtra(id: id, name: name, price: price);
  }

  factory ProductExtraModel.fromEntity(ProductExtra extra) {
    return ProductExtraModel(
      id: extra.id,
      name: extra.name,
      price: extra.price,
    );
  }
}

class Extra {
  final String id;
  final String name;
  final double price;

  Extra({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Extra && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

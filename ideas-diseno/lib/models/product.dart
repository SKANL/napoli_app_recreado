import 'package:barrio_napoli/models/extra.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<Extra> availableExtras;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.availableExtras = const [],
  });
}

// Datos de ejemplo
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Pizza Margherita',
    description:
        'Base salsa de tomate San Marzano, mozzarella fior di latte, parmesano, albahaca fresca. Completada con sabor napolitano contemporáneo.',
    price: 189.00,
    category: 'Pizzas',
    availableExtras: [
      Extra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25.00),
      Extra(id: 'e2', name: 'Albahaca Extra', price: 15.00),
      Extra(id: 'e3', name: 'Aceitunas', price: 20.00),
    ],
  ),
  Product(
    id: '2',
    name: 'Pizza Pepperoni',
    description:
        'Salsa de tomate, mozzarella, pepperoni italiano, orégano y un toque de aceite de oliva.',
    price: 219.00,
    category: 'Pizzas',
    availableExtras: [
      Extra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25.00),
      Extra(id: 'e4', name: 'Pepperoni Extra', price: 35.00),
      Extra(id: 'e5', name: 'Jalapeños', price: 15.00),
    ],
  ),
  Product(
    id: '3',
    name: 'Lasagna Bolognesa',
    description:
        'Capas de pasta fresca con salsa bolognesa tradicional, bechamel y queso parmesano gratinado.',
    price: 159.00,
    category: 'Pastas',
    availableExtras: [],
  ),
  Product(
    id: '4',
    name: 'Pizza Cuatro Quesos',
    description:
        'Mozzarella, gorgonzola, parmesano y provolone en perfecta armonía.',
    price: 239.00,
    category: 'Pizzas',
    availableExtras: [
      Extra(id: 'e1', name: 'Extra Queso Mozzarella', price: 25.00),
    ],
  ),
  Product(
    id: '5',
    name: 'Pizza Diavola',
    description:
        'Para los que aman el picante: salami picante, chile calabrés y mozzarella.',
    price: 229.00,
    category: 'Pizzas',
    availableExtras: [
      Extra(id: 'e5', name: 'Jalapeños', price: 15.00),
      Extra(id: 'e6', name: 'Chile Extra', price: 10.00),
    ],
  ),
  // PASTAS
  Product(
    id: '6',
    name: 'Spaghetti Carbonara',
    description:
        'Pasta clásica italiana con salsa de huevo, queso parmesano, panceta crujiente y pimienta negra.',
    price: 149.00,
    category: 'Pastas',
    availableExtras: [
      Extra(id: 'e7', name: 'Queso Extra', price: 15.00),
    ],
  ),
  Product(
    id: '7',
    name: 'Penne Arrabbiata',
    description:
        'Salsa de tomate, ajo, chile rojo y aceite de oliva en una receta simple pero deliciosa.',
    price: 139.00,
    category: 'Pastas',
    availableExtras: [
      Extra(id: 'e6', name: 'Chile Extra', price: 10.00),
      Extra(id: 'e7', name: 'Queso Extra', price: 15.00),
    ],
  ),
  Product(
    id: '8',
    name: 'Fettuccine Alfredo',
    description:
        'Pasta fresca con crema, mantequilla, queso parmesano y un toque de nuez moscada.',
    price: 159.00,
    category: 'Pastas',
    availableExtras: [
      Extra(id: 'e7', name: 'Queso Extra', price: 15.00),
      Extra(id: 'e8', name: 'Panceta Extra', price: 20.00),
    ],
  ),
  // POSTRES
  Product(
    id: '9',
    name: 'Tiramisu Napolitano',
    description:
        'Clásico postre italiano con capas de bizcocho embebido en café, mascarpone y cacao.',
    price: 89.00,
    category: 'Postres',
    availableExtras: [],
  ),
  Product(
    id: '10',
    name: 'Pannacotta de Frutas',
    description:
        'Crema italiana suave con frutas frescas de temporada y coulis de frambuesa.',
    price: 79.00,
    category: 'Postres',
    availableExtras: [],
  ),
  Product(
    id: '11',
    name: 'Panna Cotta de Chocolate',
    description:
        'Postre cremoso de chocolate belga con salsa de frambuesa y frutos rojos.',
    price: 85.00,
    category: 'Postres',
    availableExtras: [
      Extra(id: 'e9', name: 'Frutos Rojos Extra', price: 15.00),
    ],
  ),
  // BEBIDAS
  Product(
    id: '12',
    name: 'Refreso Natural de Limón',
    description:
        'Bebida refrescante de limón fresco, agua mineral y un toque de miel.',
    price: 35.00,
    category: 'Bebidas',
    availableExtras: [
      Extra(id: 'e10', name: 'Extra Hielo', price: 5.00),
    ],
  ),
  Product(
    id: '13',
    name: 'Agua Mineral Gasificada',
    description:
        'Agua mineral natural con gas, perfecta para acompañar tu pizza favorita.',
    price: 25.00,
    category: 'Bebidas',
    availableExtras: [],
  ),
  Product(
    id: '14',
    name: 'Refresco Artesanal de Fresa',
    description:
        'Bebida casera con fresas frescas, limón y azúcar natural, sin conservantes.',
    price: 39.00,
    category: 'Bebidas',
    availableExtras: [
      Extra(id: 'e10', name: 'Extra Hielo', price: 5.00),
    ],
  ),
  Product(
    id: '15',
    name: 'Vino Tinto Napolitano',
    description:
        'Vino tinto local de excelente calidad, perfecto para acompañar tus pizzas.',
    price: 120.00,
    category: 'Bebidas',
    availableExtras: [],
  ),
];

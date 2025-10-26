# 🎨 Guía de Colores - Napoli Pizzeria App

## Paleta de Colores Principal

Esta aplicación utiliza una paleta de colores personalizada siguiendo las mejores prácticas de Material Design 3 y la Arquitectura V5.

### Colores Primarios

```dart
// Verde Mar (Primary)
static const Color primaryGreen = Color(0xFF2E8B57);
// Uso: Botones principales, AppBar, elementos destacados
// Ejemplo: FilledButton, AppBar background
```

```dart
// Rojo Indio (Error/Accent)
static const Color primaryRed = Color(0xFFCD5C5C);
// Uso: Mensajes de error, alertas, botones de acción negativa
// Ejemplo: Botón de logout, mensajes de error
```

```dart
// Beige (Surface/Background)
static const Color backgroundBeige = Color(0xFFF5F5DC);
// Uso: Fondo de pantallas, cards, superficies
// Ejemplo: Scaffold background, Card background
```

```dart
// Gris Pizarra Oscuro (Text)
static const Color textDark = Color(0xFF2F4F4F);
// Uso: Texto principal, iconos
// Ejemplo: Body text, headings
```

```dart
// Salmón Oscuro / Terracota (Secondary)
static const Color accentTerracotta = Color(0xFFE9967A);
// Uso: Acentos secundarios, elementos decorativos
// Ejemplo: Secondary buttons, badges
```

## ColorScheme del Tema

### Modo Claro (Light Theme)

```dart
ColorScheme(
  brightness: Brightness.light,
  
  // Colores principales
  primary: primaryGreen,           // #2E8B57
  onPrimary: white,               // Texto sobre primary
  
  secondary: accentTerracotta,     // #E9967A
  onSecondary: textDark,          // Texto sobre secondary
  
  surface: backgroundBeige,        // #F5F5DC (fondos y componentes)
  onSurface: textDark,            // #2F4F4F (texto e iconos)
  
  error: primaryRed,              // #CD5C5C
  onError: white,                 // Texto sobre error
)
```

## Uso Correcto de Colores en Widgets

### ❌ INCORRECTO (hardcoded):
```dart
Container(
  color: Colors.red,           // ❌ NO HACER ESTO
  child: Text(
    'Hola',
    style: TextStyle(color: Color(0xFF2E8B57)), // ❌ NO HACER ESTO
  ),
)
```

### ✅ CORRECTO (desde el tema):
```dart
Container(
  color: Theme.of(context).colorScheme.error,  // ✅ Usar colorScheme
  child: Text(
    'Hola',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface, // ✅ Dinámico
    ),
  ),
)
```

## Mapeo de Casos de Uso

### Botones Principales
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  child: const Text('Agregar al Carrito'),
)
```

### Botones Secundarios
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.secondary,
    side: BorderSide(
      color: Theme.of(context).colorScheme.secondary,
    ),
  ),
  child: const Text('Ver Más'),
)
```

### Botones de Error/Eliminar
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.error,
    foregroundColor: Theme.of(context).colorScheme.onError,
  ),
  child: const Text('Eliminar'),
)
```

### Fondos de Pantallas
```dart
Scaffold(
  backgroundColor: Theme.of(context).colorScheme.surface,
  // ...
)
```

### Texto Principal
```dart
Text(
  'Título Principal',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.bold,
  ),
)
```

### Texto Secundario/Subtítulos
```dart
Text(
  'Descripción secundaria',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
  ),
)
```

### Iconos
```dart
Icon(
  Icons.star,
  color: Theme.of(context).colorScheme.primary,
)
```

### Cards
```dart
Card(
  color: Theme.of(context).colorScheme.surface,
  // Los Cards ya toman el color del tema automáticamente
  child: ListTile(
    // ...
  ),
)
```

### Divisores
```dart
Divider(
  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
)
```

## Gradientes Personalizados

### Gradiente de Marca (Green → Terracotta → Red)
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,      // Verde
        Theme.of(context).colorScheme.secondary,    // Terracota
        Theme.of(context).colorScheme.error,        // Rojo
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

## Acceso a la Clase AppColors

Si necesitas acceder directamente a los colores (casos especiales):

```dart
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';

// Usar solo cuando Theme.of(context) no esté disponible
final verde = AppColors.primaryGreen;
final rojo = AppColors.primaryRed;
```

## Soporte de Tema Oscuro

La app incluye soporte para tema oscuro. Los colores se ajustan automáticamente:

```dart
// Tema Oscuro
ColorScheme(
  brightness: Brightness.dark,
  primary: primaryGreen,
  onPrimary: white,
  surface: Color(0xFF1E1E1E),  // Gris oscuro en lugar de beige
  onSurface: white,             // Texto blanco en lugar de gris oscuro
  // ...
)
```

## Testing de Colores

Para verificar que los colores se ven correctamente:

1. **Modo Claro**: Verifica el menú de 3 puntos (esquina superior derecha)
2. **Modo Oscuro**: Toca el icono de luna/sol para alternar
3. **Contraste**: Asegúrate de que todo el texto sea legible

## Arquitectura V5 - Ubicación

Los colores están definidos en:
```
lib/
└── src/
    └── core/
        └── core_ui/
            └── theme.dart  ← AQUÍ están los colores
```

## Reglas de Oro

1. ✅ **Siempre** usa `Theme.of(context).colorScheme.xxx`
2. ❌ **Nunca** uses `Colors.xxx` directamente (excepto white/black/transparent)
3. ✅ **Usa** `.withOpacity()` para variaciones de transparencia
4. ✅ **Reutiliza** los colores del ColorScheme antes de crear nuevos
5. ✅ **Documenta** cualquier uso de color custom fuera del tema

---

**Última actualización**: Octubre 2025  
**Versión**: 1.0.0  
**Arquitectura**: V5 (feature-first)

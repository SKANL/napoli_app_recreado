# 🎨 Guía de Uso de Colores - Napoli Pizza App

## 📍 Ubicación del Único Diccionario de Colores

```
lib/
└── src/
    └── core/
        └── core_ui/
            └── theme.dart  ← 🎯 AQUÍ ESTÁN TODOS LOS COLORES
```

---

## ✅ CORRECTO - Cómo Usar los Colores

### Opción 1: Desde el ColorScheme del Tema (RECOMENDADO)

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ CORRECTO: Usar Theme.of(context).colorScheme
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'Hola',
        style: TextStyle(
          // ✅ CORRECTO: Usar colorScheme dinámicamente
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
```

### Opción 2: Acceder Directamente a AppColors (Casos especiales)

```dart
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ ACEPTABLE: Usar AppColors directamente (cuando no tengas context)
      color: AppColors.primaryGreen,
      child: Icon(
        Icons.local_pizza,
        // ✅ ACEPTABLE: AppColors para iconos o elementos sin tema
        color: AppColors.grey,
      ),
    );
  }
}
```

### Opción 3: Con Opacidad/Transparencia

```dart
// ✅ CORRECTO: Modificar opacidad dinámicamente
Container(
  color: Theme.of(context)
    .colorScheme
    .onSurface
    .withOpacity(0.5),
)

// ✅ CORRECTO: Usar withAlpha para control preciso
Container(
  color: Theme.of(context)
    .colorScheme
    .onSurface
    .withAlpha((0.7 * 255).round()),
)
```

---

## ❌ INCORRECTO - Qué NO Hacer

```dart
// ❌ NUNCA hagas esto:
Container(
  color: Colors.red,  // ❌ Hardcoded - No respeta el tema
  child: Text(
    'Error',
    style: TextStyle(
      color: Color(0xFF2E8B57),  // ❌ Hardcoded - Difícil de mantener
    ),
  ),
)

// ❌ NUNCA hagas esto:
Container(
  color: const Color(0xFFF5F5DC),  // ❌ Hardcoded
)

// ❌ NUNCA hagas esto:
Icon(
  Icons.star,
  color: Color.fromARGB(255, 46, 139, 87),  // ❌ Hardcoded
)
```

---

## 🎯 Mapeo de Casos de Uso

### Fondo de Pantalla

```dart
Scaffold(
  // ✅ Usa surface para fondos de pantalla
  backgroundColor: Theme.of(context).colorScheme.surface,
  body: Container(),
)
```

### Texto Principal/Títulos

```dart
Text(
  'Mi Título',
  style: TextStyle(
    // ✅ Usa onSurface para texto principal
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  ),
)
```

### Texto Secundario/Subtítulos

```dart
Text(
  'Descripción secundaria',
  style: TextStyle(
    // ✅ Usa onSurface con opacidad reducida
    color: Theme.of(context)
      .colorScheme
      .onSurface
      .withOpacity(0.6),
  ),
)
```

### Botones Primarios

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    // ✅ Usa primary para botones destacados
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  child: const Text('Aceptar'),
)
```

### Botones Secundarios

```dart
OutlinedButton(
  onPressed: () {},
  child: const Text('Cancelar'),
)
// El tema del OutlinedButton ya usa secondary
```

### Iconos

```dart
Icon(
  Icons.local_pizza,
  // ✅ Usa primary para iconos principales
  color: Theme.of(context).colorScheme.primary,
)

Icon(
  Icons.info,
  // ✅ Usa onSurface para iconos neutros
  color: Theme.of(context).colorScheme.onSurface,
)
```

### Cards

```dart
Card(
  // ✅ Las Cards heredan automáticamente los colores del tema
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Mi contenido'),
  ),
)
```

### Divisores

```dart
Divider(
  // ✅ Usa dividerColor o onSurface con opacidad
  color: Theme.of(context)
    .colorScheme
    .onSurface
    .withOpacity(0.2),
)
```

### Errores/Alertas

```dart
Container(
  color: Colors.red,  // ❌ MAL
  
  // ✅ BIEN:
  color: Theme.of(context).colorScheme.error,
  child: Text(
    'Error: Algo salió mal',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onError,
    ),
  ),
)
```

### Gradientes de Marca

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        // ✅ Usa colores del tema para gradientes
        Theme.of(context).colorScheme.primary,       // Verde
        Theme.of(context).colorScheme.secondary,     // Terracota
        Theme.of(context).colorScheme.error,         // Rojo
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

---

## 🎨 Paleta de Colores Disponibles

### Desde el ColorScheme

| Nombre | Uso |
|--------|-----|
| `primary` | Botones principales, AppBar, elementos destacados |
| `onPrimary` | Texto/iconos sobre primary |
| `secondary` | Botones secundarios, acentos |
| `onSecondary` | Texto/iconos sobre secondary |
| `surface` | Fondos, cards, superficies |
| `onSurface` | Texto, iconos sobre surface |
| `error` | Mensajes de error, estados negativos |
| `onError` | Texto/iconos sobre error |

### Desde AppColors (Acceso Directo)

```dart
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';

AppColors.primaryGreen         // Verde principal
AppColors.primaryRed           // Rojo principal
AppColors.accentTerracotta     // Naranja/terracota
AppColors.textDark             // Gris oscuro para texto
AppColors.white                // Blanco
AppColors.grey                 // Gris neutro
AppColors.transparent          // Transparente

// Tema claro específico
AppColors.surfaceLight         // Superficie clara
AppColors.onSurfaceLight       // Texto en superficie clara
AppColors.inputFillLight       // Relleno de inputs

// Tema oscuro específico
AppColors.surfaceDark          // Superficie oscura
AppColors.onSurfaceDark        // Texto en superficie oscura
AppColors.cardDark             // Cards oscuras
AppColors.inputFillDark        // Relleno de inputs oscuro
AppColors.dividerDark          // Divisores oscuros
```

---

## 🌓 Cómo Funciona el Soporte de Tema Oscuro

La aplicación detecta automáticamente si el dispositivo está en modo oscuro:

```dart
// ✅ El código se adapta automáticamente:
Color myColor = Theme.of(context).colorScheme.onSurface;

// En tema claro → Color(0xFF212121) - texto oscuro
// En tema oscuro → Color(0xFFF2F2F2) - texto claro
```

**No necesitas IF statements para temas oscuros** 🎉

---

## 🔧 Si Necesitas Crear un Nuevo Color

### Paso 1: Agrégalo a AppColors

```dart
// En lib/src/core/core_ui/theme.dart
class AppColors {
  // ... colores existentes ...
  
  // ✅ Nuevo color
  static const Color myNewColor = Color(0xFF123456);
}
```

### Paso 2: Úsalo en tu Widget

```dart
// ✅ Opción A: Si es para un tema específico, úsalo directo
Container(color: AppColors.myNewColor)

// ✅ Opción B: Si debe adaptarse al tema, agégalo al ColorScheme
// (modifica getLightTheme() y getDarkTheme() en theme.dart)
```

---

## 📏 Convenios de Opacidad

```dart
// 100% opacity
.withOpacity(1.0)  o  .withAlpha((1.0 * 255).round())

// 90% opacity
.withOpacity(0.9)  o  .withAlpha((0.9 * 255).round())

// 70% opacity (texto secundario)
.withOpacity(0.7)  o  .withAlpha((0.7 * 255).round())

// 50% opacity (texto deshabilitado)
.withOpacity(0.5)  o  .withAlpha((0.5 * 255).round())

// 20% opacity (bordes tenues)
.withOpacity(0.2)  o  .withAlpha((0.2 * 255).round())

// 0% opacity (invisible)
.withOpacity(0.0)  o  Colors.transparent
```

---

## ✨ Reglas de Oro

1. **✅ Siempre** usa `Theme.of(context).colorScheme` para colores dinámicos
2. **✅ Usa** `AppColors` solo cuando no tengas acceso a `context`
3. **❌ Nunca** hardcodes colores con `Color(0x...)` en widgets
4. **✅ Reutiliza** colores del ColorScheme antes de crear nuevos
5. **✅ Documenta** cualquier color custom fuera del tema
6. **✅ Prueba** tanto tema claro como oscuro después de agregar colores
7. **✅ Mantén** la coherencia visual siguiendo la paleta

---

## 🐛 Checklist para Code Review

Cuando revises código relacionado con colores, verifica:

- [ ] ¿Usa `Theme.of(context).colorScheme`?
- [ ] ¿O usa `AppColors` con justificación válida?
- [ ] ¿Hay `Color(0x...)` hardcodeados? ❌ No debería haber
- [ ] ¿Hay `Colors.red`, `Colors.blue`, etc? ❌ No debería haber
- [ ] ¿Se ve bien en tema claro Y oscuro?
- [ ] ¿El contraste es adecuado? (WCAG AA)
- [ ] ¿Se usa opacidad correctamente?

---

## 📚 Documentación Relacionada

- **Definición de Colores**: `lib/src/core/core_ui/theme.dart`
- **Guía de Colores**: `COLORES.md`
- **Análisis de Centralización**: `ANALISIS_COLORES.md`
- **Material Design 3**: https://m3.material.io/

---

**Última actualización**: Octubre 27, 2025
**Mantenedor**: Team Architecture
**Versión**: 1.0.0

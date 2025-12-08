import 'package:injectable/injectable.dart';

@lazySingleton
class BusinessHoursService {
  // Horarios de atención por día de la semana
  // 1 = Lunes, 2 = Martes, ..., 7 = Domingo
  static const Map<int, Map<String, int>> _businessHours = {
    1: {'open': 17, 'close': 23}, // Lunes: 5:00 PM - 11:00 PM
    2: {'open': -1, 'close': -1}, // Martes: CERRADO
    3: {'open': 13, 'close': 23}, // Miércoles: 1:00 PM - 11:00 PM
    4: {'open': 13, 'close': 23}, // Jueves: 1:00 PM - 11:00 PM
    5: {'open': 13, 'close': 23}, // Viernes: 1:00 PM - 11:00 PM
    6: {'open': 13, 'close': 23}, // Sábado: 1:00 PM - 11:00 PM
    7: {'open': 14, 'close': 22}, // Domingo: 2:00 PM - 10:00 PM
  };

  /// Verifica si el negocio está abierto en este momento
  bool isOpen() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Lunes, 7 = Domingo
    final currentHour = now.hour;

    final hours = _businessHours[weekday];
    if (hours == null) return false;

    final openHour = hours['open'] ?? -1;
    final closeHour = hours['close'] ?? -1;

    // Si está cerrado todo el día
    if (openHour == -1 || closeHour == -1) return false;

    // Verificar si está dentro del horario
    return currentHour >= openHour && currentHour < closeHour;
  }

  /// Verifica si está cerca de cerrar (1 hora antes)
  bool isClosingSoon() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final currentHour = now.hour;

    final hours = _businessHours[weekday];
    if (hours == null) return false;

    final closeHour = hours['close'] ?? -1;
    if (closeHour == -1) return false;

    // Si falta 1 hora o menos para cerrar
    return currentHour == closeHour - 1;
  }

  /// Obtiene el mensaje de horarios
  String getBusinessHoursMessage() {
    return '''
Horarios de Atención:
• Lunes: 5:00 PM - 11:00 PM
• Martes: CERRADO
• Miércoles a Sábado: 1:00 PM - 11:00 PM
• Domingo: 2:00 PM - 10:00 PM
    ''';
  }

  /// Obtiene el próximo horario de apertura
  String getNextOpeningTime() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final currentHour = now.hour;

    // Si es hoy mismo pero antes de abrir
    final todayHours = _businessHours[weekday];
    if (todayHours != null) {
      final openHour = todayHours['open'] ?? -1;
      if (openHour != -1 && currentHour < openHour) {
        return 'Hoy a las ${_formatHour(openHour)}';
      }
    }

    // Buscar el siguiente día abierto
    for (int i = 1; i <= 7; i++) {
      final nextDay = (weekday % 7) + 1;
      final nextDayHours = _businessHours[nextDay];

      if (nextDayHours != null) {
        final openHour = nextDayHours['open'] ?? -1;
        if (openHour != -1) {
          final dayName = _getDayName(nextDay);
          return '$dayName a las ${_formatHour(openHour)}';
        }
      }
    }

    return 'Próximamente';
  }

  /// Obtiene el horario de hoy
  String getTodayHours() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final hours = _businessHours[weekday];

    if (hours == null) return 'CERRADO';

    final openHour = hours['open'] ?? -1;
    final closeHour = hours['close'] ?? -1;

    if (openHour == -1 || closeHour == -1) return 'CERRADO';

    return '${_formatHour(openHour)} - ${_formatHour(closeHour)}';
  }

  /// Formatea la hora en formato 12 horas
  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  /// Obtiene el nombre del día
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }
}

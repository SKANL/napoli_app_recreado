import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Servicio para persistir historial de cupones ganados
class CouponHistoryService {
  static const String _key = 'coupon_history';
  
  /// Guardar un cupón ganado
  Future<void> saveCoupon(String couponCode) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    
    // Agregar nuevo cupón con timestamp
    final couponEntry = jsonEncode({
      'code': couponCode,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    history.add(couponEntry);
    await prefs.setStringList(_key, history);
  }
  
  /// Obtener todos los cupones ganados
  Future<List<Map<String, dynamic>>> getCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    
    return history.map((entry) {
      final Map<String, dynamic> decoded = jsonDecode(entry);
      return {
        'code': decoded['code'],
        'timestamp': DateTime.parse(decoded['timestamp']),
      };
    }).toList();
  }
  
  /// Limpiar historial
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
  
  /// Obtener cantidad de cupones ganados
  Future<int> getCouponCount() async {
    final coupons = await getCoupons();
    return coupons.length;
  }
}

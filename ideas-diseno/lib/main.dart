import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/providers/theme_provider.dart';
import 'package:barrio_napoli/screens/cart_screen.dart';
import 'package:barrio_napoli/screens/main_screen.dart';
import 'package:barrio_napoli/screens/order_status_screen.dart';
import 'package:barrio_napoli/screens/login_screen_v3.dart';
import 'package:barrio_napoli/theme/app_theme.dart';

void main() {
  runApp(const BarrioNapoliApp());
}

class BarrioNapoliApp extends StatelessWidget {
  const BarrioNapoliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Barrio Napoli',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreenV3(),
              '/main': (context) => const MainScreen(),
              '/cart': (context) => const CartScreen(),
              '/order_status': (context) => const OrderStatusScreen(),
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'di.dart';
import 'core/core_ui/theme.dart';
import 'core/core_ui/theme_controller.dart';
import 'core/core_ui/theme_provider.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    initDi();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      controller: _themeController,
      child: Builder(builder: (context) {
        final tc = ThemeProvider.of(context);
        return AnimatedBuilder(
          animation: tc,
          builder: (context, _) {
            return MaterialApp(
              title: 'Pizzeria UI',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: tc.dark ? ThemeMode.dark : ThemeMode.light,
              home: const SplashScreen(),
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeProvider.of(context);
    return IconButton(
      icon: Icon(controller.dark ? Icons.dark_mode : Icons.light_mode),
      onPressed: controller.toggle,
      tooltip: 'Toggle theme',
    );
  }
}

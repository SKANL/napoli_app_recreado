import 'package:flutter/material.dart';
import '../../../../core/core_ui/widgets/app_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.local_pizza, size: 120, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          const Text('Pizza Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Login')),
        ]),
      ),
    );
  }
}

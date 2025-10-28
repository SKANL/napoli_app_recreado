import 'dart:async';
import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/order_stepper.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/features/home/presentation/screens/home_screen.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({super.key});

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  int _currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startOrderProgress();
  }

  void _startOrderProgress() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else {
        timer.cancel();
        _showRatingDialog();
      }
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.accentTerracotta,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              '¡Pedido Entregado!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Cómo fue tu experiencia?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_rounded),
                  iconSize: 36,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  color: AppColors.accentTerracotta,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _finishOrder();
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _finishOrder();
            },
            child: Text(
              'Más tarde',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finishOrder() {
    // Limpiamos el carrito antes de volver a la pantalla principal
    cartService.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Estado del Pedido',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.primaryGreen),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  '¿Salir del seguimiento?',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Tu pedido seguirá en proceso. Puedes volver en cualquier momento.',
                  style: theme.textTheme.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round())),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _finishOrder();
                    },
                    child: Text(
                      'Salir',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundBeige,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Pedido #${DateTime.now().millisecondsSinceEpoch % 10000}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            OrderStepper(currentStep: _currentStep),
            const SizedBox(height: 30),
            if (_currentStep == 2) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 60,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Mapa en tiempo real',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withAlpha((0.1 * 255).round()),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryGreen,
                              child: Icon(
                                Icons.person,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Carlos Rodríguez',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Tu repartidor',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone),
                              color: AppColors.primaryGreen,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _currentStep == 0
                    ? '¡Gracias por tu pedido! Estamos trabajando en ello.'
                    : _currentStep == 1
                        ? 'Nuestros chefs están preparando tu comida con amor.'
                        : _currentStep == 2
                            ? '¡Ya casi llega! Tu comida está en camino.'
                            : '¡Disfruta tu comida deliciosa!',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

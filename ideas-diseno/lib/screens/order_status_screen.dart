import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/widgets/order_stepper.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/screens/main_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
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
            const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB300),
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              '¡Pedido Entregado!',
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B5E20),
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
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_rounded),
                  iconSize: 40,
                  color: const Color(0xFFFFB300),
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
              style: GoogleFonts.roboto(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finishOrder() {
    // Limpiamos el carrito antes de volver a la pantalla principal
    // Usamos listen: false porque estamos en un método, no en el build.
    Provider.of<CartProvider>(context, listen: false).clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Estado del Pedido',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1B5E20)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  '¿Salir del seguimiento?',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Tu pedido seguirá en proceso. Puedes volver en cualquier momento.',
                  style: GoogleFonts.roboto(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.roboto(color: Colors.grey.shade600),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _finishOrder();
                    },
                    child: Text(
                      'Salir',
                      style: GoogleFonts.roboto(
                        color: const Color(0xFFB53229),
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
                color: const Color(0xFFF5E6D3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    color: Color(0xFF1B5E20),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pedido #${DateTime.now().millisecondsSinceEpoch % 10000}',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
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
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.map,
                            size: 60,
                            color: Color(0xFF1B5E20),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Mapa en tiempo real',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey.shade600,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFF1B5E20),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Carlos Rodríguez',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Tu repartidor',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone),
                              color: const Color(0xFF1B5E20),
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
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey.shade700,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStepper extends StatelessWidget {
  final int currentStep;

  const OrderStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStep(
            context: context,
            stepNumber: 0,
            title: 'Pedido Confirmado',
            subtitle: 'Hemos recibido tu pedido',
            icon: Icons.check_circle,
          ),
          _buildConnector(0),
          _buildStep(
            context: context,
            stepNumber: 1,
            title: 'En Preparación',
            subtitle: 'Tu comida se está preparando con amor',
            icon: Icons.restaurant_menu,
          ),
          _buildConnector(1),
          _buildStep(
            context: context,
            stepNumber: 2,
            title: 'Repartidor en Camino',
            subtitle: '¡Tu pedido ya va hacia ti!',
            icon: Icons.delivery_dining,
          ),
          _buildConnector(2),
          _buildStep(
            context: context,
            stepNumber: 3,
            title: 'Entregado',
            subtitle: '¡Disfruta tu comida!',
            icon: Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required int stepNumber,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isCompleted = stepNumber <= currentStep;
    final isCurrent = stepNumber == currentStep;

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF1B5E20) : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: const Color(0xFF1B5E20).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : Colors.grey.shade600,
            size: 26,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFF1B5E20)
                      : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(int stepNumber) {
    final isCompleted = stepNumber < currentStep;

    return Container(
      margin: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
      width: 3,
      height: 30,
      color: isCompleted ? const Color(0xFF1B5E20) : Colors.grey.shade300,
    );
  }
}

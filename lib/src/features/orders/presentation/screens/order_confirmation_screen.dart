import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/services/cart.service.dart';
import 'package:napoli_app_v1/src/features/orders/presentation/screens/order_placed_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressNumberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isProcessingPayment = false;

  @override
  void dispose() {
    _addressController.dispose();
    _addressNumberController.dispose();
    _complementController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    // Validar que los campos obligatorios estén llenos
    if (_addressController.text.isEmpty ||
        _addressNumberController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor completa los datos obligatorios (*)',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    // Simular procesamiento de pago (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isProcessingPayment = false);

      // Navegar a la pantalla de estado del pedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OrderPlacedScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        title: Text(
          'Confirmar Pedido',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen del pedido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha((0.05 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ValueListenableBuilder<List<CartItem>>(
                  valueListenable: cartService,
                  builder: (context, items, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen del Pedido',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.quantity}x ${item.name}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (item.selectedExtras.isNotEmpty)
                                        Text(
                                          'Extras: ${item.selectedExtras.map((e) => e.name).join(", ")}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice} MXN',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 16, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: theme.textTheme.bodyMedium),
                            Text(
                              '\$${cartService.subtotal} MXN',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Envío:', style: theme.textTheme.bodyMedium),
                            Text(
                              '\$${cartService.deliveryFee} MXN',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        if (cartService.discount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_offer, color: AppColors.primaryGreen, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Descuento (${cartService.appliedCoupon!.code}):',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '-\$${cartService.discount} MXN',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundBeige,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              Text(
                                '\$${cartService.total} MXN',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Tiempo estimado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBeige,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tiempo estimado: 25-35 min',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Formulario de dirección
              Text(
                'Dirección de Envío',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),

              // Calle
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Calle *',
                  hintText: 'Ej: Calle Principal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),

              // Número y complemento en fila
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _addressNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número *',
                        hintText: 'Ej: 123',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _complementController,
                      decoration: InputDecoration(
                        labelText: 'Apto/Depto (opcional)',
                        hintText: 'Ej: Apto 5B',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Teléfono
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono *',
                  hintText: 'Ej: +52 55 1234-5678',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),

              // Notas especiales
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notas especiales (opcional)',
                  hintText: 'Ej: Tocar timbre 3 veces, dejar en puerta, etc.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Botón de pago
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    disabledBackgroundColor: theme.disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isProcessingPayment
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Procesar Pago',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Información de seguridad
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBeige,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: AppColors.primaryGreen, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Este es un pago de simulación. No se realizará ningún cargo.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

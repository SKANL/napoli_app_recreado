import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/providers/cart_provider.dart';
import 'package:barrio_napoli/screens/order_status_screen.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/custom_widgets.dart';

class OrderConfirmationScreenV2 extends StatefulWidget {
  const OrderConfirmationScreenV2({super.key});

  @override
  State<OrderConfirmationScreenV2> createState() =>
      _OrderConfirmationScreenV2State();
}

class _OrderConfirmationScreenV2State extends State<OrderConfirmationScreenV2>
    with SingleTickerProviderStateMixin {
  late TextEditingController _addressController;
  late TextEditingController _addressNumberController;
  late TextEditingController _complementController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late AnimationController _animationController;

  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    final cart = Provider.of<CartProvider>(context, listen: false);
    _addressController = TextEditingController(text: cart.address);
    _addressNumberController = TextEditingController(text: cart.addressNumber);
    _complementController = TextEditingController(text: cart.addressComplement);
    _phoneController = TextEditingController(text: cart.phone);
    _notesController = TextEditingController(text: cart.specialNotes);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _addressNumberController.dispose();
    _complementController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (_addressController.text.isEmpty ||
        _addressNumberController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor completa todos los campos obligatorios (*)',
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
      return;
    }

    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.setDeliveryInfo(
      address: _addressController.text,
      addressNumber: _addressNumberController.text,
      addressComplement: _complementController.text,
      phone: _phoneController.text,
      specialNotes: _notesController.text,
    );

    setState(() => _isProcessingPayment = true);

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isProcessingPayment = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OrderStatusScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAF7F2),
          appBar: AppBar(
            title: const Text('Confirmar Pedido'),
            backgroundColor: const Color(0xFFF5E6D3),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF3D2817)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                  parent: _animationController, curve: Curves.easeIn),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resumen del pedido
                    _buildOrderSummaryCard(cart),
                    const SizedBox(height: AppTheme.spacingL),

                    // Información de entrega
                    _buildDeliveryInfoCard(),
                    const SizedBox(height: AppTheme.spacingL),

                    // Datos de dirección
                    _buildDeliveryDetailsSection(),
                    const SizedBox(height: AppTheme.spacingL),

                    // Botón de pago
                    _buildPaymentSection(),
                    const SizedBox(height: AppTheme.spacingM),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummaryCard(CartProvider cart) {
    return RoundedCard(
      shadows: [AppTheme.shadowMedium],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del Pedido',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...cart.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.quantity}x ${item.product.name}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (item.selectedExtras.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Extras: ${item.selectedExtras.map((e) => e.name).join(", ")}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PriceTag(price: item.totalPrice),
                ],
              ),
            );
          }),
          const DecoSeparator(),
          _buildPriceRow('Subtotal:', cart.subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Envío:', cart.deliveryFee),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.accentCream,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                PriceTag(price: cart.total, isLarge: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Row(
      children: [
        Expanded(
          child: InfoCard(
            title: 'Tiempo de entrega',
            value: '25-35 min',
            icon: Icons.access_time,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: InfoCard(
            title: 'Costo de envío',
            value: 'Incluido',
            icon: Icons.local_shipping,
            backgroundColor: Color(0xFFF0F8FF),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dirección de Envío',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spacingL),
        CustomTextField(
          label: 'Calle',
          hint: 'Ej: Calle Principal',
          controller: _addressController,
          isRequired: true,
          prefixIcon: Icons.location_on,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomTextField(
                label: 'Número',
                hint: 'Ej: 123',
                controller: _addressNumberController,
                keyboardType: TextInputType.number,
                isRequired: true,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Apto/Depto',
                hint: 'Ej: 5B',
                controller: _complementController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingL),
        Text(
          'Información de Contacto',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spacingL),
        CustomTextField(
          label: 'Teléfono',
          hint: 'Ej: +54 9 11 1234-5678',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          isRequired: true,
          prefixIcon: Icons.phone,
        ),
        const SizedBox(height: AppTheme.spacingM),
        CustomTextField(
          label: 'Notas especiales',
          hint: 'Ej: Tocar timbre 3 veces, dejar en puerta...',
          controller: _notesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    final formattedPrice = amount.toStringAsFixed(2);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          '\$$formattedPrice',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: [
        CustomButton(
          label: 'Procesar Pago',
          onPressed: _processPayment,
          isLoading: _isProcessingPayment,
          icon: Icons.payment,
        ),
        const SizedBox(height: AppTheme.spacingM),
        RoundedCard(
          backgroundColor: const Color(0xFFF0F8FF),
          shadows: [AppTheme.shadowSmall],
          child: Row(
            children: [
              const Icon(
                Icons.lock,
                color: AppTheme.primaryGreen,
                size: 18,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Text(
                  'Pago simulado. No se realizará ningún cargo real.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:napoli_app_v1/src/features/cart/presentation/cubit/cart_state.dart';

import '../../../settings/presentation/screens/saved_addresses_screen.dart';
import '../../../settings/presentation/screens/payment_methods_screen.dart';
import 'bank_transfer_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:napoli_app_v1/src/features/orders/domain/entities/order.dart';
import 'package:napoli_app_v1/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:napoli_app_v1/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:napoli_app_v1/src/core/services/business_hours.service.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/business_closed_dialog.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import '../widgets/delivery_address_section.dart';
import '../widgets/payment_method_selector.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OrdersCubit>()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: BlocListener<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderSaved) {
            context.read<CartCubit>().clearCart();
            context.go('/order-placed');
          } else if (state is OrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al procesar el pedido: ${state.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: const _OrderConfirmationContent(),
      ),
    );
  }
}

class _OrderConfirmationContent extends StatefulWidget {
  const _OrderConfirmationContent();

  @override
  State<_OrderConfirmationContent> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<_OrderConfirmationContent> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressNumberController =
      TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isProcessingPayment = false;
  AddressModel? _selectedAddress;
  bool _useManualAddress = false;

  // Variables para método de pago
  String _selectedPaymentMethod = 'efectivo';
  PaymentMethodModel? _selectedCard;

  // Variables para transferencia bancaria
  bool _transferConfirmed = false;

  // Feature flag: Habilitar/deshabilitar tarjetas guardadas
  // NOTA: Cambiar a true cuando el panel de admin esté listo para soportar pagos con tarjeta
  static const bool _enableSavedCards = false;

  // Direcciones simuladas (en una app real vendrían de una base de datos o servicio)
  final List<AddressModel> _savedAddresses = [
    AddressModel(
      id: '1',
      label: 'Casa',
      address: 'Calle Principal 123, Col. Centro',
      city: 'Ciudad de México',
      details: 'Casa blanca con portón negro',
      isDefault: true,
    ),
    AddressModel(
      id: '2',
      label: 'Trabajo',
      address: 'Av. Reforma 456, Piso 8',
      city: 'Ciudad de México',
      details: 'Oficina 804, Torre B',
      isDefault: false,
    ),
  ];

  // Métodos de pago disponibles (simulados)
  final List<PaymentMethodModel> _savedCards = [
    PaymentMethodModel(
      id: '1',
      type: PaymentType.card,
      cardNumber: '**** **** **** 1234',
      cardHolder: 'JUAN PEREZ',
      expiryDate: '12/28',
      cardBrand: 'Visa',
      isDefault: true,
    ),
    PaymentMethodModel(
      id: '2',
      type: PaymentType.card,
      cardNumber: '**** **** **** 5678',
      cardHolder: 'JUAN PEREZ',
      expiryDate: '03/27',
      cardBrand: 'Mastercard',
      isDefault: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Seleccionar automáticamente la dirección predeterminada
    if (_savedAddresses.isNotEmpty) {
      _selectedAddress = _savedAddresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => _savedAddresses.first,
      );
    }

    // Seleccionar automáticamente la tarjeta predeterminada
    if (_savedCards.isNotEmpty) {
      _selectedCard = _savedCards.firstWhere(
        (card) => card.isDefault,
        orElse: () => _savedCards.first,
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _addressNumberController.dispose();
    _complementController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleTransferTap() async {
    final result =
        await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BankTransferScreen(
                  totalAmount: context.read<CartCubit>().state.total.toDouble(),
                ),
              ),
            )
            as Map<String, dynamic>?;

    if (result != null && result['confirmed'] == true) {
      setState(() {
        _selectedPaymentMethod = 'transferencia';
        _transferConfirmed = true;
        _selectedCard = null;
      });
    }
  }

  void _processPayment() async {
    final l10n = AppLocalizations.of(context)!;
    // Validar horarios de atención
    // Validar horarios de atención
    final businessHoursService = getIt<BusinessHoursService>();
    if (!businessHoursService.isOpen()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BusinessClosedDialog(
          nextOpeningTime: businessHoursService.getNextOpeningTime(),
          schedule: businessHoursService.getBusinessHoursMessage(),
        ),
      );
      return;
    }

    // Validar dirección
    if (_selectedAddress == null &&
        (_addressController.text.isEmpty ||
            _addressNumberController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.selectAddressOrManual,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Validar teléfono
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.enterPhoneNumber,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Validar transferencia confirmada
    if (_selectedPaymentMethod == 'transferencia' && !_transferConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.completeTransferData,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    // Obtener usuario actual
    // Obtener usuario actual
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : 'guest';

    // Crear orden
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: context.read<CartCubit>().state.items,
      total: context.read<CartCubit>().state.total,
      status: OrderStatus.pending,
      date: DateTime.now(),
      address: _selectedAddress != null
          ? '${_selectedAddress!.address}, ${_selectedAddress!.city}'
          : '${_addressController.text} ${_addressNumberController.text}, ${_complementController.text}',
      paymentMethod: _selectedPaymentMethod,
    );

    // Guardar orden usando OrdersCubit
    await context.read<OrdersCubit>().saveOrder(order);

    if (mounted) {
      setState(() => _isProcessingPayment = false);
      // BlocListener handles navigation on success
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.confirmOrder,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
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
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha((0.05 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final items = state.items;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.orderSummary,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.quantity}x ${item.name}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (item.selectedExtras.isNotEmpty)
                                        Text(
                                          l10n.extras(
                                            item.selectedExtras
                                                .map((e) => e.name)
                                                .join(", "),
                                          ),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withAlpha(
                                                      (0.6 * 255).round(),
                                                    ),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice} MXN',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
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
                            Text(
                              l10n.subtotal,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '\$${state.subtotal} MXN',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.deliveryFee,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '\$${state.deliveryFee} MXN',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (state.discount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    color: theme.colorScheme.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.discountWithCode(
                                      state.appliedCoupon!.code,
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '-\$${state.discount} MXN',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.total,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '\$${state.total} MXN',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
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
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.estimatedTime,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sección de dirección de envío
              DeliveryAddressSection(
                savedAddresses: _savedAddresses,
                selectedAddress: _selectedAddress,
                useManualAddress: _useManualAddress,
                phoneController: _phoneController,
                notesController: _notesController,
                addressController: _addressController,
                onChangeAddress: () => _showAddressSelectionDialog(theme),
                onManualAddressToggle: (value) =>
                    setState(() => _useManualAddress = value),
              ),
              const SizedBox(height: 20),

              // Sección de método de pago
              PaymentMethodSelector(
                selectedPaymentMethod: _selectedPaymentMethod,
                transferConfirmed: _transferConfirmed,
                selectedCard: _selectedCard,
                savedCards: _savedCards,
                enableSavedCards: _enableSavedCards,
                onMethodChanged: (value) => setState(() {
                  _selectedPaymentMethod = value;
                  _selectedCard = null;
                }),
                onCardSelected: (card) => setState(() {
                  _selectedPaymentMethod = 'card';
                  _selectedCard = card;
                }),
                onTransferTap: _handleTransferTap,
              ),
              const SizedBox(height: 20),

              // Botón de pago
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onSecondary,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _getPaymentButtonText(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Información de seguridad
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.simulationMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(
                            (0.7 * 255).round(),
                          ),
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

  void _showAddressSelectionDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Dirección'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _savedAddresses.length,
            itemBuilder: (context, index) {
              final address = _savedAddresses[index];
              final isSelected = _selectedAddress?.id == address.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getLabelColor(
                        address.label,
                        theme,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getLabelIcon(address.label),
                      color: _getLabelColor(address.label, theme),
                      size: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        address.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Predeterminada',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${address.address}, ${address.city}'),
                      if (address.details.isNotEmpty)
                        Text(
                          address.details,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                  onTap: () {
                    setState(() {
                      _selectedAddress = address;
                      _useManualAddress = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedAddressesScreen(),
                ),
              );
            },
            child: const Text('Gestionar Direcciones'),
          ),
        ],
      ),
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'casa':
      case 'home':
        return Icons.home;
      case 'trabajo':
      case 'work':
        return Icons.work;
      case 'universidad':
      case 'uni':
      case 'escuela':
        return Icons.school;
      case 'gimnasio':
        return Icons.fitness_center;
      case 'familia':
        return Icons.family_restroom;
      case 'amigos':
        return Icons.people;
      case 'otro':
      case 'other':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  Color _getLabelColor(String label, ThemeData theme) {
    switch (label.toLowerCase()) {
      case 'casa':
      case 'home':
        return Colors.green;
      case 'trabajo':
      case 'work':
        return Colors.blue;
      case 'universidad':
      case 'uni':
      case 'escuela':
        return Colors.purple;
      case 'gimnasio':
        return Colors.orange;
      case 'familia':
        return Colors.pink;
      case 'amigos':
        return Colors.teal;
      case 'otro':
      case 'other':
        return Colors.grey;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _getPaymentButtonText() {
    if (_selectedPaymentMethod == 'transferencia') {
      return 'Confirmar Transferencia';
    } else if (_selectedPaymentMethod == 'card') {
      return 'Pagar con Tarjeta';
    }
    return 'Confirmar Pedido';
  }
}

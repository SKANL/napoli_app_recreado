import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:flutter/services.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethodModel> paymentMethods = [
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.paymentMethodsTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.colorScheme.primary),
            onPressed: () => _showAddPaymentMethodDialog(context),
          ),
        ],
      ),
      body: paymentMethods.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  paymentMethods.length + 1, // +1 para métodos alternativos
              itemBuilder: (context, index) {
                if (index < paymentMethods.length) {
                  return _buildPaymentMethodCard(
                    context,
                    theme,
                    paymentMethods[index],
                    index,
                  );
                } else {
                  return _buildAlternativePaymentMethods(theme);
                }
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPaymentMethodDialog(context),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addCard),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noPaymentMethods,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noPaymentMethodsDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddPaymentMethodDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addFirstCard),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    ThemeData theme,
    PaymentMethodModel paymentMethod,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: _getCardGradient(paymentMethod.cardBrand),
        borderRadius: BorderRadius.circular(16),
        border: paymentMethod.isDefault
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón de fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.1),
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: CustomPaint(painter: CardPatternPainter()),
            ),
          ),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con logo y acciones
                Row(
                  children: [
                    // Logo de la marca
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        paymentMethod.cardBrand.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Badge predeterminada
                    if (paymentMethod.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.defaultLabel,
                          style: TextStyle(
                            color: _getCardGradient(
                              paymentMethod.cardBrand,
                            ).colors.first,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),

                    // Menú de opciones
                    PopupMenuButton<String>(
                      onSelected: (value) => _handlePaymentMethodAction(
                        value,
                        paymentMethod,
                        index,
                      ),
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      itemBuilder: (context) => [
                        if (!paymentMethod.isDefault)
                          PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.setAsDefault,
                                ),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 20),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.edit),
                            ],
                          ),
                        ),
                        if (!paymentMethod.isDefault)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.delete,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Número de tarjeta
                Text(
                  paymentMethod.cardNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),

                const SizedBox(height: 16),

                // Información inferior
                Row(
                  children: [
                    // Titular
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.cardHolderLabel,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            paymentMethod.cardHolder,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fecha de expiración
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.expiryLabel,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          paymentMethod.expiryDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativePaymentMethods(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.alternativeMethods,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        // Efectivo
        _buildAlternativePaymentTile(
          theme,
          icon: Icons.money,
          title: AppLocalizations.of(context)!.cash,
          subtitle: AppLocalizations.of(context)!.cashSubtitle,
          color: Colors.green,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.cashAvailable),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        // Transferencia
        _buildAlternativePaymentTile(
          theme,
          icon: Icons.account_balance,
          title: AppLocalizations.of(context)!.bankTransfer,
          subtitle: AppLocalizations.of(context)!.bankTransferSubtitle,
          color: Colors.blue,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.bankTransferComingSoon,
                ),
                backgroundColor: theme.colorScheme.secondary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAlternativePaymentTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  LinearGradient _getCardGradient(String cardBrand) {
    switch (cardBrand.toLowerCase()) {
      case 'visa':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        );
      case 'mastercard':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
        );
      case 'amex':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF424242), Color(0xFF757575)],
        );
    }
  }

  void _handlePaymentMethodAction(
    String action,
    PaymentMethodModel paymentMethod,
    int index,
  ) {
    switch (action) {
      case 'default':
        _setAsDefault(index);
        break;
      case 'edit':
        _showEditPaymentMethodDialog(context, paymentMethod, index);
        break;
      case 'delete':
        _showDeleteConfirmation(context, paymentMethod, index);
        break;
    }
  }

  void _setAsDefault(int index) {
    setState(() {
      // Quitar predeterminada actual
      for (var method in paymentMethods) {
        method.isDefault = false;
      }
      // Establecer nueva predeterminada
      paymentMethods[index].isDefault = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.cardSetAsDefault(
            paymentMethods[index].cardBrand,
            paymentMethods[index].cardNumber.split(' ').last,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PaymentMethodModel paymentMethod,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePaymentMethodTitle),
        content: Text(
          AppLocalizations.of(context)!.deletePaymentMethodConfirmation(
            paymentMethod.cardBrand,
            paymentMethod.cardNumber.split(' ').last,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethods.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.paymentMethodDeleted(paymentMethod.cardBrand),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    _showPaymentMethodFormDialog(context, null, null);
  }

  void _showEditPaymentMethodDialog(
    BuildContext context,
    PaymentMethodModel paymentMethod,
    int index,
  ) {
    _showPaymentMethodFormDialog(context, paymentMethod, index);
  }

  void _showPaymentMethodFormDialog(
    BuildContext context,
    PaymentMethodModel? paymentMethod,
    int? index,
  ) {
    final isEditing = paymentMethod != null;
    final cardNumberController = TextEditingController(
      text: isEditing
          ? paymentMethod.cardNumber.replaceAll('*', '').replaceAll(' ', '')
          : '',
    );
    final cardHolderController = TextEditingController(
      text: paymentMethod?.cardHolder ?? '',
    );
    final expiryController = TextEditingController(
      text: paymentMethod?.expiryDate ?? '',
    );
    final cvvController = TextEditingController();

    bool isDefault = paymentMethod?.isDefault ?? paymentMethods.isEmpty;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            isEditing
                ? AppLocalizations.of(context)!.editCardTitle
                : AppLocalizations.of(context)!.addCardTitle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Número de tarjeta
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.cardNumberLabel,
                    hintText: '1234 5678 9012 3456',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberInputFormatter(),
                  ],
                ),
                const SizedBox(height: 16),

                // Titular
                TextField(
                  controller: cardHolderController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(
                      context,
                    )!.cardHolderNameLabel,
                    hintText: 'JUAN PEREZ',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),

                // Fecha de expiración y CVV
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.expiryDateLabel,
                          hintText: 'MM/AA',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpiryDateInputFormatter(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.cvvLabel,
                          hintText: '123',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hacer predeterminada
                CheckboxListTile(
                  title: Text(AppLocalizations.of(context)!.setAsDefaultLabel),
                  value: isDefault,
                  onChanged: (value) {
                    setDialogState(() {
                      isDefault = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 8),

                // Información de seguridad
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.securityInfo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (cardNumberController.text.length >= 16 &&
                    cardHolderController.text.isNotEmpty &&
                    expiryController.text.length == 5 &&
                    cvvController.text.length >= 3) {
                  final cardBrand = _getCardBrand(cardNumberController.text);
                  final maskedCardNumber = _maskCardNumber(
                    cardNumberController.text,
                  );

                  final newPaymentMethod = PaymentMethodModel(
                    id:
                        paymentMethod?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    type: PaymentType.card,
                    cardNumber: maskedCardNumber,
                    cardHolder: cardHolderController.text.toUpperCase(),
                    expiryDate: expiryController.text,
                    cardBrand: cardBrand,
                    isDefault: isDefault,
                  );

                  setState(() {
                    if (isDefault) {
                      // Quitar predeterminada actual
                      for (var method in paymentMethods) {
                        method.isDefault = false;
                      }
                    }

                    if (isEditing && index != null) {
                      paymentMethods[index] = newPaymentMethod;
                    } else {
                      paymentMethods.add(newPaymentMethod);
                    }
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? AppLocalizations.of(context)!.cardUpdated
                            : AppLocalizations.of(context)!.cardAdded,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Por favor completa todos los campos',
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  String _getCardBrand(String cardNumber) {
    final number = cardNumber.replaceAll(' ', '');
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5') || number.startsWith('2')) return 'Mastercard';
    if (number.startsWith('3')) return 'Amex';
    return 'Tarjeta';
  }

  String _maskCardNumber(String cardNumber) {
    final number = cardNumber.replaceAll(' ', '');
    if (number.length >= 4) {
      final lastFour = number.substring(number.length - 4);
      return '**** **** **** $lastFour';
    }
    return cardNumber;
  }
}

// Modelo para métodos de pago
enum PaymentType { card, cash, transfer }

class PaymentMethodModel {
  final String id;
  final PaymentType type;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardBrand;
  bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardBrand,
    required this.isDefault,
  });
}

// Formateador para número de tarjeta
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Formateador para fecha de expiración
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Painter para el patrón de fondo de la tarjeta
class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Círculos decorativos
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 30, paint);

    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.7), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

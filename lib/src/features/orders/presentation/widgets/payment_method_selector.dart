import 'package:flutter/material.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedPaymentMethod;
  final bool transferConfirmed;
  final PaymentMethodModel? selectedCard;
  final List<PaymentMethodModel> savedCards;
  final bool enableSavedCards;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<PaymentMethodModel> onCardSelected;
  final VoidCallback onTransferTap;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.transferConfirmed,
    required this.selectedCard,
    required this.savedCards,
    required this.enableSavedCards,
    required this.onMethodChanged,
    required this.onCardSelected,
    required this.onTransferTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Método de Pago',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Opciones de método de pago
          Column(
            children: [
              // Efectivo
              _buildPaymentOption(
                theme,
                'efectivo',
                'Efectivo',
                'Pagar al recibir el pedido',
                Icons.money,
                Colors.green,
              ),

              const SizedBox(height: 8),

              // Transferencia
              InkWell(
                onTap: onTransferTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedPaymentMethod == 'transferencia'
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    border: Border.all(
                      color: selectedPaymentMethod == 'transferencia'
                          ? theme.colorScheme.primary
                          : theme.dividerColor.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (transferConfirmed ? Colors.green : Colors.blue)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: transferConfirmed ? Colors.green : Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transferConfirmed
                                  ? 'Transferencia Confirmada ✓'
                                  : 'Transferencia',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: selectedPaymentMethod == 'transferencia'
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              transferConfirmed
                                  ? 'Comprobante adjuntado correctamente'
                                  : 'SPEI o transferencia bancaria',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: 'transferencia',
                        groupValue: selectedPaymentMethod,
                        onChanged:
                            null, // Deshabilitar, el tap lo maneja InkWell
                        activeColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tarjetas guardadas
              if (enableSavedCards && savedCards.isNotEmpty) ...[
                ...savedCards
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildCardPaymentOption(theme, card),
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    ThemeData theme,
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    final isSelected = selectedPaymentMethod == value;

    return InkWell(
      onTap: () => onMethodChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (newValue) {
                if (newValue != null) onMethodChanged(newValue);
              },
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentOption(ThemeData theme, PaymentMethodModel card) {
    final isSelected = selectedCard?.id == card.id;

    return InkWell(
      onTap: () => onCardSelected(card),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getCardColor(card.cardBrand).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.credit_card,
                color: _getCardColor(card.cardBrand),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${card.cardBrand} ${card.cardNumber}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (card.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Predeterminada',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    card.cardHolder,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: 'card_${card.id}',
              groupValue: isSelected
                  ? 'card_${card.id}'
                  : selectedPaymentMethod,
              onChanged: (newValue) => onCardSelected(card),
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(String cardBrand) {
    switch (cardBrand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A237E);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

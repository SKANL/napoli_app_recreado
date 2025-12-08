import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'all';

  final List<String> filters = ['all', 'delivered', 'in_progress', 'cancelled'];

  List<OrderHistoryModel> orders = [
    OrderHistoryModel(
      id: '#ORD-2024-001',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: OrderStatus.delivered,
      items: [
        OrderItemModel(name: 'Pizza Margherita', quantity: 1, price: 189.00),
        OrderItemModel(name: 'Coca Cola 355ml', quantity: 2, price: 35.00),
      ],
      total: 259.00,
      paymentMethod: 'Visa **** 1234',
      deliveryAddress: 'Calle Revolución 123, Col. Centro',
      deliveryTime: '25-35 min',
      rating: 5,
    ),
    OrderHistoryModel(
      id: '#ORD-2024-002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.delivered,
      items: [
        OrderItemModel(
          name: 'Pizza Pepperoni Familiar',
          quantity: 1,
          price: 299.00,
        ),
        OrderItemModel(name: 'Alitas BBQ (8 pzs)', quantity: 1, price: 159.00),
        OrderItemModel(name: 'Refresco 2L', quantity: 1, price: 45.00),
      ],
      total: 503.00,
      paymentMethod: 'Efectivo',
      deliveryAddress: 'Av. Universidad 456, Col. Del Valle',
      deliveryTime: '30-40 min',
      rating: 4,
    ),
    OrderHistoryModel(
      id: '#ORD-2024-003',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: OrderStatus.inProgress,
      items: [
        OrderItemModel(name: 'Pizza Hawaiana', quantity: 2, price: 179.00),
        OrderItemModel(name: 'Pan de Ajo', quantity: 1, price: 65.00),
      ],
      total: 423.00,
      paymentMethod: 'Mastercard **** 5678',
      deliveryAddress: 'Calle Morelos 789, Col. Doctores',
      deliveryTime: '20-30 min',
      rating: null,
    ),
    OrderHistoryModel(
      id: '#ORD-2024-004',
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: OrderStatus.cancelled,
      items: [
        OrderItemModel(name: 'Pizza Suprema', quantity: 1, price: 249.00),
      ],
      total: 249.00,
      paymentMethod: 'Visa **** 1234',
      deliveryAddress: 'Calle Hidalgo 321, Col. Roma Norte',
      deliveryTime: '35-45 min',
      rating: null,
      cancellationReason: 'Cancelado por el cliente',
    ),
    OrderHistoryModel(
      id: '#ORD-2024-005',
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: OrderStatus.delivered,
      items: [
        OrderItemModel(name: 'Pizza Cuatro Quesos', quantity: 1, price: 219.00),
        OrderItemModel(name: 'Ensalada César', quantity: 1, price: 89.00),
        OrderItemModel(name: 'Agua Natural 600ml', quantity: 2, price: 25.00),
      ],
      total: 333.00,
      paymentMethod: 'Transferencia',
      deliveryAddress: 'Calle Insurgentes 654, Col. Condesa',
      deliveryTime: '25-35 min',
      rating: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderHistoryModel> get filteredOrders {
    switch (selectedFilter) {
      case 'delivered':
        return orders
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
      case 'in_progress':
        return orders
            .where((order) => order.status == OrderStatus.inProgress)
            .toList();
      case 'cancelled':
        return orders
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      default:
        return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.purchaseHistoryTitle,
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.6,
          ),
          indicatorColor: theme.colorScheme.primary,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.recentTab),
            Tab(text: AppLocalizations.of(context)!.favoritesTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Recientes
          _buildRecentOrdersTab(theme),
          // Tab Favoritos
          _buildFavoritesTab(theme),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersTab(ThemeData theme) {
    return Column(
      children: [
        // Filtros
        _buildFilters(theme),

        // Lista de órdenes
        Expanded(
          child: filteredOrders.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(
                      context,
                      theme,
                      filteredOrders[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getFilterName(context, filter)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFilterName(BuildContext context, String filter) {
    switch (filter) {
      case 'all':
        return AppLocalizations.of(context)!.filterAll;
      case 'delivered':
        return AppLocalizations.of(context)!.filterDelivered;
      case 'in_progress':
        return AppLocalizations.of(context)!.filterInProgress;
      case 'cancelled':
        return AppLocalizations.of(context)!.filterCancelled;
      default:
        return filter;
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    String message;
    IconData icon;

    switch (selectedFilter) {
      case 'in_progress':
        message = AppLocalizations.of(context)!.noOrdersInProgress;
        icon = Icons.hourglass_empty;
        break;
      case 'cancelled':
        message = AppLocalizations.of(context)!.noOrdersCancelled;
        icon = Icons.cancel_outlined;
        break;
      case 'delivered':
        message = AppLocalizations.of(context)!.noOrdersDelivered;
        icon = Icons.check_circle_outline;
        break;
      default:
        message = AppLocalizations.of(context)!.noOrders;
        icon = Icons.shopping_bag_outlined;
    }

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
              child: Icon(icon, size: 60, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.ordersEmptyDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    ThemeData theme,
    OrderHistoryModel order,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(context, order),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con ID y fecha
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(context, order.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(theme, order.status),
                ],
              ),

              const SizedBox(height: 12),

              // Items del pedido
              ...order.items
                  .take(2)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '${item.quantity}x ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              // Mostrar más items si existen
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.moreProducts(order.items.length - 2),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Footer con total y acciones
              Row(
                children: [
                  // Método de pago
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getPaymentIcon(order.paymentMethod),
                          size: 14,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.paymentMethod,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Total
                  Text(
                    '${AppLocalizations.of(context)!.totalLabel}\$${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              // Acciones específicas por estado
              if (order.status == OrderStatus.delivered && order.rating == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showRatingDialog(context, order),
                      icon: const Icon(Icons.star_outline, size: 18),
                      label: Text(AppLocalizations.of(context)!.rateOrder),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                ),

              if (order.status == OrderStatus.delivered && order.rating != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < order.rating!
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.yourRating(order.rating!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (order.status == OrderStatus.inProgress)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _trackOrder(context, order),
                          icon: const Icon(Icons.location_on, size: 18),
                          label: Text(AppLocalizations.of(context)!.trackOrder),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _reorderItems(context, order),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(AppLocalizations.of(context)!.orderAgain),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (order.status == OrderStatus.cancelled)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          order.cancellationReason ??
                              AppLocalizations.of(context)!.orderCancelled,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.delivered:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        text = AppLocalizations.of(context)!.statusDelivered;
        icon = Icons.check_circle;
        break;
      case OrderStatus.inProgress:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        text = AppLocalizations.of(context)!.statusInProgress;
        icon = Icons.access_time;
        break;
      case OrderStatus.cancelled:
        backgroundColor = theme.colorScheme.error.withValues(alpha: 0.1);
        textColor = theme.colorScheme.error;
        text = AppLocalizations.of(context)!.statusCancelled;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteProductsList(ThemeData theme) {
    // Calcular productos más pedidos
    final Map<String, int> productCount = {};
    final Map<String, double> productPrice = {};

    for (final order in orders.where(
      (o) => o.status == OrderStatus.delivered,
    )) {
      for (final item in order.items) {
        productCount[item.name] =
            (productCount[item.name] ?? 0) + item.quantity;
        productPrice[item.name] = item.price;
      }
    }

    final sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedProducts.take(5).map((entry) {
        final productName = entry.key;
        final quantity = entry.value;
        final price = productPrice[productName] ?? 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_pizza,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.orderedTimes(quantity),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFavoritesTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.yourFavorites,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.favoritesDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),

          _buildFavoriteProductsList(theme),

          const SizedBox(height: 32),

          // Acción para reordenar favoritos
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _reorderFavorites(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.orderFavorites),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String paymentMethod) {
    if (paymentMethod.toLowerCase().contains('visa')) {
      return Icons.credit_card;
    }
    if (paymentMethod.toLowerCase().contains('mastercard')) {
      return Icons.credit_card;
    }
    if (paymentMethod.toLowerCase().contains('efectivo')) {
      return Icons.money;
    }
    if (paymentMethod.toLowerCase().contains('transferencia')) {
      return Icons.account_balance;
    }
    return Icons.payment;
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return AppLocalizations.of(
          context,
        )!.timeAgoMinutes(difference.inMinutes);
      }
      return AppLocalizations.of(context)!.timeAgoHours(difference.inHours);
    } else if (difference.inDays == 1) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (difference.inDays < 7) {
      return AppLocalizations.of(context)!.timeAgoDays(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOrderDetails(BuildContext context, OrderHistoryModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  _formatDate(context, order.date),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusChip(Theme.of(context), order.status),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Items
                      Text(
                        'Productos',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      ...order.items.map(
                        (item) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.local_pizza,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'Cantidad: ${item.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Información de entrega
                      Text(
                        'Información de Entrega',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      _buildInfoTile(
                        Theme.of(context),
                        Icons.location_on,
                        'Dirección',
                        order.deliveryAddress,
                      ),

                      _buildInfoTile(
                        Theme.of(context),
                        Icons.access_time,
                        'Tiempo estimado',
                        order.deliveryTime,
                      ),

                      _buildInfoTile(
                        Theme.of(context),
                        _getPaymentIcon(order.paymentMethod),
                        'Método de pago',
                        order.paymentMethod,
                      ),

                      const SizedBox(height: 24),

                      // Total
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Acciones
                      if (order.status == OrderStatus.delivered)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _reorderItems(context, order);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Pedir Otra Vez'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    ThemeData theme,
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, OrderHistoryModel order) {
    int selectedRating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Calificar Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Cómo fue tu experiencia con este pedido?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: () {
                      setDialogState(() {
                        selectedRating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  order.rating = selectedRating;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '¡Gracias por tu calificación de $selectedRating estrellas!',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Calificar'),
            ),
          ],
        ),
      ),
    );
  }

  void _trackOrder(BuildContext context, OrderHistoryModel order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rastreando pedido ${order.id}...'),
        action: SnackBarAction(
          label: 'Ver en mapa',
          onPressed: () {
            // Navegar a pantalla de tracking
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reorderItems(BuildContext context, OrderHistoryModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedir Otra Vez'),
        content: Text(
          '¿Quieres agregar los productos de este pedido (${order.id}) al carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Productos agregados al carrito'),
                  action: SnackBarAction(
                    label: 'Ver carrito',
                    onPressed: () {
                      // Navegar al carrito
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Agregar al Carrito'),
          ),
        ],
      ),
    );
  }

  void _reorderFavorites(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Agregando favoritos al carrito...'),
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () {
            // Navegar al carrito
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Modelos
enum OrderStatus { delivered, inProgress, cancelled }

class OrderHistoryModel {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final List<OrderItemModel> items;
  final double total;
  final String paymentMethod;
  final String deliveryAddress;
  final String deliveryTime;
  int? rating;
  final String? cancellationReason;

  OrderHistoryModel({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.deliveryTime,
    this.rating,
    this.cancellationReason,
  });
}

class OrderItemModel {
  final String name;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

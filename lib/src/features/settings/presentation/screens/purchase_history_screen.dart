import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/order_history.dart';
import 'package:napoli_app_v1/src/features/settings/domain/repositories/order_history_repository.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/favorite_products_list.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/order_details_sheet.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/order_history_card.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<OrderHistory> orders;
  String selectedFilter = 'all';

  final List<String> filters = ['all', 'delivered', 'in_progress', 'cancelled'];
  late final OrderHistoryRepository _repository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repository = getIt<OrderHistoryRepository>();
    orders = _repository.getOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderHistory> get filteredOrders {
    switch (selectedFilter) {
      case 'delivered':
        return orders
            .where((order) => order.status == OrderHistoryStatus.delivered)
            .toList();
      case 'in_progress':
        return orders
            .where((order) => order.status == OrderHistoryStatus.inProgress)
            .toList();
      case 'cancelled':
        return orders
            .where((order) => order.status == OrderHistoryStatus.cancelled)
            .toList();
      default:
        return orders;
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
          l10n.purchaseHistoryTitle,
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
            Tab(text: l10n.recentTab),
            Tab(text: l10n.favoritesTab),
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
                    final order = filteredOrders[index];
                    return OrderHistoryCard(
                      order: order,
                      onTap: () => _showOrderDetails(context, order),
                      onReorder: () => _reorderItems(context, order),
                      onTrack: () => _trackOrder(context, order),
                      onRate: (rating) => _handleRateOrder(order, rating),
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
    final l10n = AppLocalizations.of(context)!;
    switch (filter) {
      case 'all':
        return l10n.filterAll;
      case 'delivered':
        return l10n.filterDelivered;
      case 'in_progress':
        return l10n.filterInProgress;
      case 'cancelled':
        return l10n.filterCancelled;
      default:
        return filter;
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    String message;
    IconData icon;

    switch (selectedFilter) {
      case 'in_progress':
        message = l10n.noOrdersInProgress;
        icon = Icons.hourglass_empty;
        break;
      case 'cancelled':
        message = l10n.noOrdersCancelled;
        icon = Icons.cancel_outlined;
        break;
      case 'delivered':
        message = l10n.noOrdersDelivered;
        icon = Icons.check_circle_outline;
        break;
      default:
        message = l10n.noOrders;
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
              l10n.ordersEmptyDesc,
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

  Widget _buildFavoritesTab(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourFavorites,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.favoritesDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),

          FavoriteProductsList(orders: orders),

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
              label: Text(l10n.orderFavorites),
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _showOrderDetails(BuildContext context, OrderHistory order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(
        order: order,
        onReorder: () => _reorderItems(context, order),
      ),
    );
  }

  void _handleRateOrder(OrderHistory order, int rating) {
    setState(() {
      // In a real app, this would call a repository to update the order
      // We need to find the order in our list and update 'rating'
      // Since our Mock Repository returns new instances or we have a local copy in 'orders':
      // We are mutating the local 'order' reference which might work if references match,
      // but to be safe and cleaner (and immutable-ish):
      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        // As OrderHistory is equatable/immutable, we should replace it
        // But our entity fields are final. We need to implement copyWith or similar
        // NOTE: I added copyWith to OrderHistory entity in previous step.
        orders[index] = orders[index].copyWith(rating: rating);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Gracias por tu calificación de $rating estrellas!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _trackOrder(BuildContext context, OrderHistory order) {
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

  void _reorderItems(BuildContext context, OrderHistory order) {
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

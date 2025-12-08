import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/coupon_history.service.dart';

class CouponHistoryScreen extends StatefulWidget {
  const CouponHistoryScreen({super.key});

  @override
  State<CouponHistoryScreen> createState() => _CouponHistoryScreenState();
}

class _CouponHistoryScreenState extends State<CouponHistoryScreen> {
  final CouponHistoryService _historyService = CouponHistoryService();
  List<Map<String, dynamic>> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() => _isLoading = true);
    final coupons = await _historyService.getCoupons();
    setState(() {
      _coupons = coupons.reversed.toList(); // Más recientes primero
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context)!.confirmTitle),
        content: Text(AppLocalizations.of(context)!.clearHistoryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.clearAll),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _historyService.clearHistory();
      _loadCoupons();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.historyCleared)),
        );
      }
    }
  }

  String _getCouponDescription(String code) {
    switch (code) {
      case 'PIZZA10':
        return AppLocalizations.of(context)!.discount10;
      case 'SAVE20':
        return AppLocalizations.of(context)!.discount20;
      case 'MEGA50':
        return AppLocalizations.of(context)!.discount50;
      default:
        return AppLocalizations.of(context)!.specialCoupon;
    }
  }

  Color _getCouponColor(BuildContext context, String code) {
    switch (code) {
      case 'PIZZA10':
        return Theme.of(context).colorScheme.primary;
      case 'SAVE20':
        return Theme.of(context).colorScheme.secondary;
      case 'MEGA50':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(
          context,
        ).colorScheme.onSurface.withAlpha((0.6 * 255).round());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myCoupons),
        actions: [
          if (_coupons.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearHistory,
              tooltip: AppLocalizations.of(context)!.clearHistoryTooltip,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _coupons.isEmpty
          ? _buildEmptyState()
          : _buildCouponList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noCouponsTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.75 * 255).round()),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noCouponsSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.65 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(
            context,
          ).colorScheme.primary.withAlpha((0.1 * 255).round()),
          child: Row(
            children: [
              Icon(
                Icons.celebration,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.couponsWon(_coupons.length),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _coupons.length,
            itemBuilder: (context, index) {
              final coupon = _coupons[index];
              final code = coupon['code'] as String;
              final timestamp = coupon['timestamp'] as DateTime;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCouponColor(
                        context,
                        code,
                      ).withAlpha((0.2 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_offer,
                      color: _getCouponColor(context, code),
                      size: 28,
                    ),
                  ),
                  title: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        _getCouponDescription(code),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.wonDate(
                          DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((0.7 * 255).round()),
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha((0.06 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha((0.18 * 255).round()),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.activeStatus,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

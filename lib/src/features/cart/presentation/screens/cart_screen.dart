import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/services/cart.service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _discount = 0;
  String? _appliedCoupon;

  // Mock discount codes
  final Map<String, double> _discountCodes = {
    'PIZZA10': 10,
    'SAVE20': 20,
    'MEGA50': 50,
  };

  void _applyCoupon() {
    final code = _couponController.text.toUpperCase();
    if (_discountCodes.containsKey(code)) {
      setState(() {
        _discount = _discountCodes[code]!;
        _appliedCoupon = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon "$code" applied! ${_discount.toInt()}% off')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code')),
      );
    }
  }

  void _removeCoupon() {
    setState(() {
      _discount = 0;
      _appliedCoupon = null;
      _couponController.clear();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          // Header
          AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your', style: TextStyle(fontSize: 16)),
                Text('Cart', style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Cart items
          Expanded(
            child: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartService,
              builder: (context, items, _) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animation/eating.json',
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tu carrito está vacío',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha((0.75 * 255).round()),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¡Agrega deliciosas pizzas!',
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round())),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(it.image),
                          backgroundColor: Theme.of(context).dividerColor.withAlpha((0.12 * 255).round()),
                        ),
                        title: Text(it.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Size: ${it.size} • \$${it.price} MXN'),
                        trailing: IconButton(
                          onPressed: () => cartService.removeItem(it.id),
                          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Coupon section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: const InputDecoration(
                          labelText: 'Coupon Code',
                          border: OutlineInputBorder(),
                          hintText: 'Enter discount code',
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyCoupon,
                      child: const Text('Apply'),
                    ),
                  ],
                ),
                if (_appliedCoupon != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coupon "$_appliedCoupon" applied ($_discount% off)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        TextButton(onPressed: _removeCoupon, child: const Text('Remove')),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Total & Checkout
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: cartService,
                  builder: (context, items, _) {
                    final subtotal = cartService.total;
                    final discountAmount = (subtotal * _discount / 100).round();
                    final total = subtotal - discountAmount;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                            Text('\$$subtotal MXN', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        if (_discount > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount:', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                              Text('-\$$discountAmount MXN', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                            ],
                          ),
                        const Divider(thickness: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('\$$total MXN', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: items.isEmpty
                                ? null
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Checkout functionality - UI only')),
                                    );
                                  },
                            child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

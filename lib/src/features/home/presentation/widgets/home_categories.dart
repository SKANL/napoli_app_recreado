import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/features/products/presentation/cubit/products_cubit.dart';

class HomeCategories extends StatelessWidget {
  final String selectedCategory;

  const HomeCategories({super.key, required this.selectedCategory});

  static const List<String> _internalCategories = [
    'Todos',
    'Pizzas',
    'Pastas',
    'Bebidas',
    'Postres',
  ];

  String _getCategoryDisplayName(String internal, AppLocalizations l10n) {
    switch (internal) {
      case 'Todos':
        return l10n.catAll;
      case 'Pizzas':
        return l10n.catPizzas;
      case 'Pastas':
        return l10n.catPastas;
      case 'Bebidas':
        return l10n.catDrinks;
      case 'Postres':
        return l10n.catDesserts;
      default:
        return internal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _internalCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final internalCat = _internalCategories[index];
          final label = _getCategoryDisplayName(internalCat, l10n);
          final selected = internalCat == selectedCategory;
          return GestureDetector(
            onTap: () => context.read<ProductsCubit>().filterProducts(
              category: internalCat,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  color: selected
                      ? AppColors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(label),
              ),
            ),
          );
        },
      ),
    );
  }
}

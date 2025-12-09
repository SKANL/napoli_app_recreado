import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'dart:math' as math;

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bannerController;
  late final Animation<double> _bannerAnim;

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _bannerAnim = CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _bannerAnim,
        builder: (context, child) {
          final dx = math.sin(_bannerAnim.value * math.pi * 2) * 6;
          final opacity = 0.9 + 0.1 * _bannerAnim.value;
          return Transform.translate(
            offset: Offset(dx, 0),
            child: Opacity(opacity: opacity, child: child),
          );
        },
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Container(
              decoration: const BoxDecoration(
                // Gradiente cálido de pizzería: naranja fuego → rojo CTA
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.fireOrange,
                    AppColors.primaryRed,
                    AppColors.toastedRed,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/etiqueta.png',
                      width: 44,
                      height: 44,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.specialOffers,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.specialOfferDesc,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.25),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

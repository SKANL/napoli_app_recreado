import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/di.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/pressable_scale.dart';
import '../../presentation/cubit/auth_cubit.dart';
import '../../presentation/cubit/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';
import '../widgets/login_background_painter.dart';

/// Login screen adapted from the design references in `ideas-diseno`.
/// This implementation follows the project's architecture and uses
/// the centralized theme/colors. It contains a tabbed Login/Register UI
/// and a social login strip. Registration is also supported and will
/// set a local flag in SharedPreferences for demo purposes.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: const _LoginScreenContent(),
      ),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreenContent>
    with SingleTickerProviderStateMixin {
  bool _isSignIn = true;

  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      body: Stack(
        children: [
          // Animated custom painted background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (context, child) => CustomPaint(
                painter: LoginBackgroundPainter(
                  _bgAnimation.value,
                  colorScheme,
                ),
              ),
            ),
          ),

          // Foreground content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with subtle floating + rotation animation (gives a lively, artisanal feel)
                  AnimatedBuilder(
                    animation: _bgAnimation,
                    builder: (context, child) {
                      final dy =
                          (0.5 - _bgAnimation.value) *
                          8; // slightly larger float
                      final angle =
                          math.sin(_bgAnimation.value * math.pi * 2) *
                          0.04; // small rotation
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.rotate(angle: angle, child: child),
                      );
                    },
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.secondary.withAlpha(
                              (0.25 * 255).round(),
                            ),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primaryRed.withAlpha(
                            (0.6 * 255).round(),
                          ),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/logo_fondo_blanco-transpa.png',
                          fit: BoxFit.contain,
                          // constrain the image so it visually matches the previous icon size
                          width: 56,
                          height: 56,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.welcomeTo,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'BARRIO NAPOLI',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // subtle red accent divider to balance the palette
                  Container(
                    height: 4,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withAlpha(
                        (0.06 * 255).round(),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Card with tabs
                  AnimatedBuilder(
                    animation: _bgAnimation,
                    builder: (context, child) {
                      // small entrance translate driven by bg animation
                      final ty =
                          (1 - _bgAnimation.value) * 8; // slides up slightly
                      final op = 0.9 + 0.1 * _bgAnimation.value;
                      return Transform.translate(
                        offset: Offset(0, ty),
                        child: Opacity(
                          opacity: op,
                          child: AnimatedScale(
                            scale: _isSignIn ? 1.0 : 0.995,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withAlpha(
                              (0.08 * 255).round(),
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Tabs
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isSignIn = true),
                                  child: Column(
                                    children: [
                                      Text(
                                        l10n.signInTab,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: _isSignIn
                                                  ? colorScheme.primary
                                                  : colorScheme.onSurface
                                                        .withAlpha(
                                                          (0.6 * 255).round(),
                                                        ),
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (_isSignIn)
                                        Container(
                                          height: 3,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _isSignIn = false),
                                  child: Column(
                                    children: [
                                      Text(
                                        l10n.signUpTab,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: !_isSignIn
                                                  ? colorScheme.primary
                                                  : colorScheme.onSurface
                                                        .withAlpha(
                                                          (0.6 * 255).round(),
                                                        ),
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (!_isSignIn)
                                        Container(
                                          height: 3,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Animated form
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isSignIn
                                ? const LoginForm()
                                : const RegisterForm(),
                          ),

                          const SizedBox(height: 16),

                          // Social strip
                          Column(
                            children: [
                              Text(
                                l10n.orLoginWith,
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _socialButtonColored(
                                      context,
                                      Icons.email_outlined,
                                      'Google',
                                      AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _socialButtonColored(
                                      context,
                                      Icons.facebook_outlined,
                                      'Facebook',
                                      AppColors.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _socialButtonColored(
                                      context,
                                      Icons.apple,
                                      'Apple',
                                      AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Footer link
                          GestureDetector(
                            onTap: () => setState(() => _isSignIn = !_isSignIn),
                            child: Text(
                              _isSignIn
                                  ? '${l10n.dontHaveAccount} ${l10n.registerAction}'
                                  : '${l10n.alreadyHaveAccount} ${l10n.loginAction}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withAlpha(
                                  (0.8 * 255).round(),
                                ),
                              ),
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
        ],
      ),
    );
  }

  Widget _socialButtonColored(
    BuildContext context,
    IconData icon,
    String label,
    Color bgColor,
  ) {
    return PressableScale(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label login coming soon!'))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

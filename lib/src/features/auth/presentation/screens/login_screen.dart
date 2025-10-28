import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme.dart';
import 'package:napoli_app_v1/src/core/core_ui/widgets/app_scaffold.dart';
import 'package:napoli_app_v1/src/features/home/presentation/screens/home_screen.dart';

/// Login screen adapted from the design references in `ideas-diseno`.
/// This implementation follows the project's architecture and uses
/// the centralized theme/colors. It contains a tabbed Login/Register UI
/// and a social login strip. Registration is also supported and will
/// set a local flag in SharedPreferences for demo purposes.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isSignIn = true;
  bool _loading = false;

  final _signInKey = GlobalKey<FormState>();
  final _signUpKey = GlobalKey<FormState>();

  final _emailSignIn = TextEditingController();
  final _passwordSignIn = TextEditingController();

  final _nameSignUp = TextEditingController();
  final _emailSignUp = TextEditingController();
  final _passwordSignUp = TextEditingController();
  final _confirmSignUp = TextEditingController();

  @override
  void dispose() {
    _emailSignIn.dispose();
    _passwordSignIn.dispose();
    _nameSignUp.dispose();
    _emailSignUp.dispose();
    _passwordSignUp.dispose();
    _confirmSignUp.dispose();
    _bgController.dispose();
    super.dispose();
  }

  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
    _bgAnimation = CurvedAnimation(parent: _bgController, curve: Curves.easeInOut);
  }

  Future<void> _doSignIn() async {
    if (!_signInKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Future<void> _doSignUp() async {
    if (!_signUpKey.currentState!.validate()) return;
    if (_passwordSignUp.text != _confirmSignUp.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa tu correo';
    if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v)) return 'Correo inválido';
    return null;
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      body: Stack(
        children: [
          // Animated custom painted background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (context, child) => CustomPaint(
                painter: _LoginBackgroundPainter(_bgAnimation.value, colorScheme),
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
                      final dy = (0.5 - _bgAnimation.value) * 8; // slightly larger float
                      final angle = math.sin(_bgAnimation.value * math.pi * 2) * 0.04; // small rotation
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.rotate(
                          angle: angle,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.secondary.withAlpha((0.25 * 255).round()),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.accentBeige.withAlpha((0.6 * 255).round()),
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.local_pizza, size: 56, color: colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Bienvenido a', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('BARRIO NAPOLI', style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w900, color: colorScheme.primary)),
                  const SizedBox(height: 20),
                  // subtle red accent divider to balance the palette
                  Container(height: 4, width: 120, decoration: BoxDecoration(color: AppColors.primaryRed.withAlpha((0.06 * 255).round()), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 10),

                  // Card with tabs
                  AnimatedBuilder(
                    animation: _bgAnimation,
                    builder: (context, child) {
                      // small entrance translate driven by bg animation
                      final ty = (1 - _bgAnimation.value) * 8; // slides up slightly
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
                        boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha((0.08 * 255).round()), blurRadius: 8, offset: const Offset(0, 6))],
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
                                      Text('INICIAR', style: theme.textTheme.titleMedium?.copyWith(color: _isSignIn ? colorScheme.primary : colorScheme.onSurface.withAlpha((0.6 * 255).round()), fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 8),
                                      if (_isSignIn)
                                        Container(height: 3, width: 48, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2))),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isSignIn = false),
                                  child: Column(
                                    children: [
                                      Text('REGISTRARSE', style: theme.textTheme.titleMedium?.copyWith(color: !_isSignIn ? colorScheme.primary : colorScheme.onSurface.withAlpha((0.6 * 255).round()), fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 8),
                                      if (!_isSignIn)
                                        Container(height: 3, width: 48, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2))),
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
                            child: _isSignIn ? _buildSignIn(theme) : _buildSignUp(theme),
                          ),

                          const SizedBox(height: 16),

                          // Social strip
                          Column(
                            children: [
                              Text('O inicia sesión con', style: theme.textTheme.bodySmall),
                              const SizedBox(height: 8),
                              Row(
                                    children: [
                                      Expanded(child: _socialButtonColored(Icons.email_outlined, 'Google', AppColors.primaryGreen)),
                                      const SizedBox(width: 8),
                                      Expanded(child: _socialButtonColored(Icons.facebook_outlined, 'Facebook', AppColors.primaryRed)),
                                      const SizedBox(width: 8),
                                      Expanded(child: _socialButtonColored(Icons.apple, 'Apple', AppColors.textDark)),
                                    ],
                                  ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Footer link
                          GestureDetector(
                            onTap: () => setState(() => _isSignIn = !_isSignIn),
                            child: Text(
                              _isSignIn ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión',
                              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withAlpha((0.8 * 255).round())),
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

  Widget _buildSignIn(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Form(
      key: _signInKey,
      child: Column(
        key: const ValueKey('signin'),
        children: [
          TextFormField(
            controller: _emailSignIn,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email)),
            validator: _emailValidator,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordSignIn,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Contraseña', prefixIcon: const Icon(Icons.lock)),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Función de recuperar contraseña aún no implementada')));
              },
              child: Text('¿Olvidaste tu contraseña?', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _PressableScale(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: AppColors.accentBeige.withAlpha((0.35 * 255).round())),
                  elevation: 3,
                ),
                onPressed: _loading ? null : _doSignIn,
                child: _loading ? const CircularProgressIndicator() : const Text('INGRESAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(ThemeData theme) {
    return Form(
      key: _signUpKey,
      child: Column(
        key: const ValueKey('signup'),
        children: [
          TextFormField(
            controller: _nameSignUp,
            decoration: const InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person)),
            validator: (v) => v == null || v.isEmpty ? 'Ingresa tu nombre' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailSignUp,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
            validator: _emailValidator,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordSignUp,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmSignUp,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirmar contraseña', prefixIcon: Icon(Icons.lock)),
            validator: (v) => v == null || v.isEmpty ? 'Confirma tu contraseña' : null,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _PressableScale(
              child: ElevatedButton(
                onPressed: _loading ? null : _doSignUp,
                child: _loading ? const CircularProgressIndicator() : const Text('REGISTRARSE'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButtonColored(IconData icon, String label, Color bgColor) {
    return _PressableScale(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label login coming soon!'))),
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

class _PressableScale extends StatefulWidget {
  final Widget child;
  const _PressableScale({required this.child});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  double _scale = 1.0;
  void _down([TapDownDetails? _]) => setState(() => _scale = 0.96);
  void _up([dynamic _]) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _down(details),
      onTapCancel: () => _up(),
      onTapUp: (details) => _up(details),
      onTap: null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  final double t; // 0..1 animation value
  final ColorScheme colors;

  _LoginBackgroundPainter(this.t, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base gradient: from a slightly muted green to a soft beige to create a warm brand backdrop
    final rect = Rect.fromLTWH(0, 0, w, h);
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.primary.withAlpha((0.92 * 255).round()),
          AppColors.accentBeigeLight.withAlpha((0.95 * 255).round()),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, basePaint);

    // Soft beige wave (lighter, blends into gradient)
  final wavePaint = Paint()..color = AppColors.accentBeige.withAlpha(((0.85 - 0.12 * t) * 255).round());
    final path = Path();
    path.moveTo(0, h * 0.55 + (t - 0.5) * 30);
    path.quadraticBezierTo(w * 0.25, h * 0.45 + (t - 0.5) * 40, w * 0.5, h * 0.58 + (t - 0.5) * 30);
    path.quadraticBezierTo(w * 0.75, h * 0.70 + (t - 0.5) * 20, w, h * 0.62 + (t - 0.5) * 30);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    canvas.drawPath(path, wavePaint);

    // Floating decorative circles: use a subtle translucent white/beige to lift the composition
  final circlePaint = Paint()..color = AppColors.white.withAlpha(((0.06 + 0.03 * t) * 255).round());
    final r = 20.0 + 8.0 * t;
    canvas.drawCircle(Offset(w * 0.14 + 40 * (t - 0.5), h * 0.16), r, circlePaint);
    canvas.drawCircle(Offset(w * 0.82 - 50 * (t - 0.5), h * 0.24), r * 0.7, circlePaint);

    // Warm accent overlay (soft) to the top-right for warm contrast
  final accentPaint = Paint()..color = AppColors.fireOrange.withAlpha(((0.06 + 0.04 * t) * 255).round());
    final terrPath = Path();
    terrPath.moveTo(w * 0.78, h * 0.02 + 10 * t);
    terrPath.quadraticBezierTo(w * 0.92, h * 0.12 + 20 * t, w * 0.72, h * 0.22);
    terrPath.quadraticBezierTo(w * 0.62, h * 0.12, w * 0.78, h * 0.02 + 10 * t);
    canvas.drawPath(terrPath, accentPaint);

    // (Decorative pizza motif removed - left the rest of the composition intact)

    // Small accent blob using onSurface with low opacity to harmonize
  final blobPaint = Paint()..color = colors.onSurface.withAlpha(((0.04 + 0.03 * (1 - t)) * 255).round());
    final blob = Path();
    blob.moveTo(w * 0.75, h * 0.05 + 20 * t);
    blob.quadraticBezierTo(w * 0.82, h * 0.18, w * 0.65, h * 0.22);
    blob.quadraticBezierTo(w * 0.55, h * 0.12, w * 0.75, h * 0.05 + 20 * t);
    canvas.drawPath(blob, blobPaint);
  }

  @override
  bool shouldRepaint(covariant _LoginBackgroundPainter old) => old.t != t || old.colors != colors;
}

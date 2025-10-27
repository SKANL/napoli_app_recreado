import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/custom_widgets.dart';

class LoginScreenV2 extends StatefulWidget {
  const LoginScreenV2({super.key});

  @override
  State<LoginScreenV2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends State<LoginScreenV2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryGreen.withOpacity(0.95),
                  AppTheme.primaryGreen,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header con logo
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusLarge,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_pizza,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        Text(
                          'Barrio Napoli',
                          style: GoogleFonts.roboto(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'La mejor pizzería de la ciudad',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),

                    // Formulario
                    Column(
                      children: [
                        Text(
                          'Bienvenido',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inicia sesión para continuar',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        RoundedCard(
                          shadows: [AppTheme.shadowLarge],
                          child: Column(
                            children: [
                              // Email
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  labelStyle: GoogleFonts.roboto(
                                    color: AppTheme.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  hintText: 'tu@email.com',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingL),

                              // Password
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle: GoogleFonts.roboto(
                                    color: AppTheme.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(
                                    Icons.lock_outlined,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingL),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Recuperación de contraseña en desarrollo',
                                          style:
                                              GoogleFonts.roboto(fontSize: 14),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: GoogleFonts.roboto(
                                      color: AppTheme.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingL),

                              // Login Button
                              CustomButton(
                                label: 'Iniciar Sesión',
                                onPressed: _handleLogin,
                                isLoading: _isLoading,
                                icon: Icons.login,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Footer
                    Column(
                      children: [
                        Text(
                          '¿No tienes cuenta?',
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registro en desarrollo',
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text(
                            'Regístrate aquí',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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

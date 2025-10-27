import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/widgets/auth_widgets.dart';
import 'package:barrio_napoli/screens/client_home_screen_v2.dart';

class LoginScreenV3 extends StatefulWidget {
  const LoginScreenV3({Key? key}) : super(key: key);

  @override
  State<LoginScreenV3> createState() => _LoginScreenV3State();
}

class _LoginScreenV3State extends State<LoginScreenV3> {
  bool _isSignIn = true;
  bool _isLoading = false;

  final _formKeySignIn = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();

  final _emailSignInController = TextEditingController();
  final _passwordSignInController = TextEditingController();

  final _nameSignUpController = TextEditingController();
  final _emailSignUpController = TextEditingController();
  final _passwordSignUpController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailSignInController.dispose();
    _passwordSignInController.dispose();
    _nameSignUpController.dispose();
    _emailSignUpController.dispose();
    _passwordSignUpController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKeySignIn.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClientHomeScreenV2()),
        );
      }
    }
  }

  void _handleSignUp() async {
    if (_formKeySignUp.currentState!.validate()) {
      if (_passwordSignUpController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClientHomeScreenV2()),
        );
      }
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email requerido';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Contraseña requerida';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Nombre requerido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        // FONDO CON DEGRADADO BEIGE/CÁLIDO (Toque de Pizzería)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3D2817), // Marrón muy oscuro (tierra)
              const Color(0xFF4A3728), // Marrón oscuro cálido
              const Color(0xFF2F1F14), // Marrón muy oscuro
            ],
          ),
        ),
        child: Stack(
          children: [
            // CÍRCULO CON GRADIENTE ROJO/NARANJA (Efecto de Horno)
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFB347), // Naranja cálido (fuego)
                        const Color(0xFFD93025), // Rojo tostado
                        const Color(0xFFA82015), // Rojo oscuro
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD93025).withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // CONTENIDO PRINCIPAL: LOGO Y FORMULARIO
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.12),

                    // LOGO EN EL CÍRCULO
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.local_pizza_outlined,
                          size: 60,
                          color: const Color(0xFFD93025).withOpacity(0.4),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.15),

                    // COMPONENTE DEL FORMULARIO (Card)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E6D3), // Beige cálido
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spacingL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SISTEMA DE PESTAÑAS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _isSignIn = true),
                                      child: Column(
                                        children: [
                                          Text(
                                            'LOGIN',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: _isSignIn
                                                  ? const Color(0xFF3D2817)
                                                  : const Color(0xFFB8A28C),
                                            ),
                                          ),
                                          SizedBox(height: AppTheme.spacingS),
                                          if (_isSignIn)
                                            Container(
                                              height: 3,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD93025),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppTheme.spacingXL),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _isSignIn = false),
                                      child: Column(
                                        children: [
                                          Text(
                                            'REGISTER',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: !_isSignIn
                                                  ? const Color(0xFF3D2817)
                                                  : const Color(0xFFB8A28C),
                                            ),
                                          ),
                                          SizedBox(height: AppTheme.spacingS),
                                          if (!_isSignIn)
                                            Container(
                                              height: 3,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD93025),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppTheme.spacingXL),

                              // FORMULARIO DINÁMICO
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _isSignIn
                                    ? _buildSignInForm()
                                    : _buildSignUpForm(),
                              ),

                              SizedBox(height: AppTheme.spacingXL),

                              // SOCIAL LOGIN SECTION
                              Column(
                                children: [
                                  Text(
                                    'O inicia sesión con',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF3D2817),
                                    ),
                                  ),
                                  SizedBox(height: AppTheme.spacingM),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: _buildSocialButton(
                                          icon: Icons.email_outlined,
                                          label: 'Google',
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Google login coming soon!'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: AppTheme.spacingM),
                                      Expanded(
                                        child: _buildSocialButton(
                                          icon: Icons.facebook_outlined,
                                          label: 'Facebook',
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Facebook login coming soon!'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: AppTheme.spacingM),
                                      Expanded(
                                        child: _buildSocialButton(
                                          icon: Icons.apple,
                                          label: 'Apple',
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Apple login coming soon!'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: AppTheme.spacingL),

                              // ENLACE INFERIOR
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isSignIn = !_isSignIn);
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _isSignIn
                                            ? '¿No tienes cuenta? '
                                            : '¿Ya tienes cuenta? ',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF3D2817),
                                        ),
                                      ),
                                      TextSpan(
                                        text: _isSignIn
                                            ? 'Regístrate'
                                            : 'Inicia sesión',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFD93025),
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
                    ),

                    SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKeySignIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInput(
            label: 'Email',
            placeholder: 'tu@email.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            controller: _emailSignInController,
            validator: _emailValidator,
          ),
          SizedBox(height: AppTheme.spacingM),
          AuthInput(
            label: 'Contraseña',
            placeholder: 'Ingresa tu contraseña',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            showPasswordToggle: true,
            controller: _passwordSignInController,
            validator: _passwordValidator,
          ),
          SizedBox(height: AppTheme.spacingS),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset coming soon!')),
                );
              },
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFD93025),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          AuthCTAButton(
            label: 'INGRESAR',
            isLoading: _isLoading,
            onPressed: _handleSignIn,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKeySignUp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInput(
            label: 'Nombre completo',
            placeholder: 'Tu nombre',
            icon: Icons.person_outline_rounded,
            controller: _nameSignUpController,
            validator: _nameValidator,
          ),
          SizedBox(height: AppTheme.spacingM),
          AuthInput(
            label: 'Email',
            placeholder: 'tu@email.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            controller: _emailSignUpController,
            validator: _emailValidator,
          ),
          SizedBox(height: AppTheme.spacingM),
          AuthInput(
            label: 'Contraseña',
            placeholder: 'Crea una contraseña fuerte',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            showPasswordToggle: true,
            controller: _passwordSignUpController,
            validator: _passwordValidator,
          ),
          SizedBox(height: AppTheme.spacingM),
          PasswordRequirements(password: _passwordSignUpController.text),
          SizedBox(height: AppTheme.spacingM),
          AuthInput(
            label: 'Confirmar contraseña',
            placeholder: 'Confirma tu contraseña',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            showPasswordToggle: true,
            controller: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirma tu contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: AppTheme.spacingL),
          AuthCTAButton(
            label: 'REGISTRARSE',
            isLoading: _isLoading,
            onPressed: _handleSignUp,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF006A4E),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/theme/app_theme.dart';

// PESTAÑA DE AUTENTICACIÓN - Sign In / Sign Up
class AuthTabBar extends StatefulWidget {
  final bool isSignIn;
  final VoidCallback onSignInTap;
  final VoidCallback onSignUpTap;

  const AuthTabBar({
    Key? key,
    required this.isSignIn,
    required this.onSignInTap,
    required this.onSignUpTap,
  }) : super(key: key);

  @override
  State<AuthTabBar> createState() => _AuthTabBarState();
}

class _AuthTabBarState extends State<AuthTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isSignIn ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(AuthTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSignIn != oldWidget.isSignIn) {
      _tabController.animateTo(
        widget.isSignIn ? 0 : 1,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      onTap: (index) {
        if (index == 0) {
          widget.onSignInTap();
        } else {
          widget.onSignUpTap();
        }
      },
      tabs: [
        Tab(
          child: Text(
            'Sign In',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Sign Up',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
      labelColor: AppTheme.primaryRed,
      unselectedLabelColor: AppTheme.darkGrey,
      indicatorColor: AppTheme.primaryRed,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// CAMPO DE ENTRADA CON ICONO
class AuthInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool showPasswordToggle;

  const AuthInput({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.showPasswordToggle = false,
  }) : super(key: key);

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixIcon: Icon(
              widget.icon,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.darkGrey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.mediumGrey,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.mediumGrey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.primaryGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.errorRed,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.errorRed,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: 12,
            ),
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400,
            ),
          ),
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

// REQUISITOS DE CONTRASEÑA
class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({
    Key? key,
    required this.password,
  }) : super(key: key);

  bool _hasUppercase() => password.contains(RegExp(r'[A-Z]'));
  bool _hasLowercase() => password.contains(RegExp(r'[a-z]'));
  bool _hasNumber() => password.contains(RegExp(r'[0-9]'));
  bool _hasSpecialChar() =>
      password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:.?/\\|`~]'));
  bool _hasMinLength() => password.length >= 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.mediumGrey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGrey,
            ),
          ),
          const SizedBox(height: 10),
          _RequirementItem(
            text: 'At least 1 uppercase letter',
            isMet: _hasUppercase(),
          ),
          _RequirementItem(
            text: 'At least 1 lowercase letter',
            isMet: _hasLowercase(),
          ),
          _RequirementItem(
            text: 'At least 1 number',
            isMet: _hasNumber(),
          ),
          _RequirementItem(
            text: 'At least 1 special character',
            isMet: _hasSpecialChar(),
          ),
          _RequirementItem(
            text: 'Minimum 8 characters',
            isMet: _hasMinLength(),
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementItem({
    Key? key,
    required this.text,
    required this.isMet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? AppTheme.primaryGreen : AppTheme.mediumGrey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isMet ? AppTheme.primaryGreen : AppTheme.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// BOTÓN CTA PRINCIPAL
class AuthCTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthCTAButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          disabledBackgroundColor: AppTheme.primaryGreen.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// BOTÓN DE SOCIAL LOGIN
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const SocialLoginButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si hay backgroundColor, usar ElevatedButton; si no, usar OutlinedButton
    if (backgroundColor != null) {
      return Expanded(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppTheme.mediumGrey,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? AppTheme.darkGrey,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ENLACE DE TEXTO CON ACCIÓN
class AuthTextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthTextLink({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$text ',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.darkGrey,
              ),
            ),
            TextSpan(
              text: linkText,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ENLACE SIMPLE
class SimpleTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const SimpleTextLink({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? AppTheme.primaryRed,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barrio_napoli/theme/app_theme.dart';

/// Botón personalizado con animación y estilos consistentes
class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: MouseRegion(
        onEnter:
            widget.isLoading ? null : (_) => _animationController.forward(),
        onExit: widget.isLoading ? null : (_) => _animationController.reverse(),
        child: ScaleTransition(
          scale: Tween<double>(begin: 1, end: 0.98).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ),
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  child: widget.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryGreen,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon),
                              const SizedBox(width: 8),
                            ],
                            Text(widget.label),
                          ],
                        ),
                )
              : ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  child: widget.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon),
                              const SizedBox(width: 8),
                            ],
                            Text(widget.label),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}

/// Campo de texto personalizado con validación
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus && widget.validator != null) {
          setState(() {
            _errorText = widget.validator!(widget.controller.text);
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.label,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.errorRed,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.maxLines == 1 ? 1 : null,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppTheme.primaryGreen)
                  : null,
              errorText: _errorText,
              errorMaxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de información con iconos
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppTheme.primaryGreen,
    this.backgroundColor = AppTheme.accentCream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta de precio mejorada
class PriceTag extends StatelessWidget {
  final double price;
  final String? label;
  final bool isLarge;

  const PriceTag({
    super.key,
    required this.price,
    this.label,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '\$',
          style: GoogleFonts.roboto(
            fontSize: isLarge ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryRed,
          ),
        ),
        Text(
          price.toStringAsFixed(2),
          style: GoogleFonts.roboto(
            fontSize: isLarge ? 28 : 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryRed,
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: 4),
          Text(
            label!,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}

/// Badge para cantidad de items
class QuantityBadge extends StatelessWidget {
  final int quantity;
  final Color? backgroundColor;

  const QuantityBadge({
    super.key,
    required this.quantity,
    this.backgroundColor = AppTheme.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          quantity.toString(),
          style: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Separador decorativo
class DecoSeparator extends StatelessWidget {
  final double height;
  final Color? color;

  const DecoSeparator({
    super.key,
    this.height = 1,
    this.color = AppTheme.mediumGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 24,
      thickness: height,
      color: color,
    );
  }
}

/// Esquina redondeada para cards
class RoundedCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double padding;
  final List<BoxShadow>? shadows;

  const RoundedCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = AppTheme.spacingM,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: shadows ?? [AppTheme.shadowSmall],
      ),
      child: child,
    );
  }
}

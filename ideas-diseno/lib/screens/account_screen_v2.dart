import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barrio_napoli/theme/app_theme.dart';
import 'package:barrio_napoli/providers/theme_provider.dart';
import 'package:barrio_napoli/widgets/custom_widgets.dart';

class AccountScreenV2 extends StatefulWidget {
  const AccountScreenV2({super.key});

  @override
  State<AccountScreenV2> createState() => _AccountScreenV2State();
}

class _AccountScreenV2State extends State<AccountScreenV2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.lightGrey,
        appBar: AppBar(
          title: Text(
            '👤 Mi Cuenta',
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          leading: const SizedBox.shrink(),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Perfil del usuario
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryGreen,
                            AppTheme.primaryGreen.withOpacity(0.7),
                          ],
                        ),
                        boxShadow: [AppTheme.shadowMedium],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nombre
                    Text(
                      'Juan Pérez',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email
                    Text(
                      'juan@email.com',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Sección de configuración
              _SettingsSection(
                title: '⚙️ Configuración',
                children: [
                  _SettingsOption(
                    icon: Icons.notifications,
                    label: 'Notificaciones',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppTheme.primaryGreen,
                    ),
                  ),
                  _SettingsOption(
                    icon: Icons.language,
                    label: 'Idioma',
                    trailing: Text(
                      'Español',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    onTap: () {},
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return _SettingsOption(
                        icon: Icons.brightness_4,
                        label: 'Modo Oscuro',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: AppTheme.primaryGreen,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Sección de información
              _SettingsSection(
                title: '📋 Información',
                children: [
                  _SettingsOption(
                    icon: Icons.phone,
                    label: 'Teléfono',
                    trailing: Text(
                      '+34 123 456 789',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    onTap: () {},
                  ),
                  _SettingsOption(
                    icon: Icons.location_on,
                    label: 'Dirección',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.darkGrey.withOpacity(0.5),
                    ),
                    onTap: () {},
                  ),
                  _SettingsOption(
                    icon: Icons.history,
                    label: 'Historial de Pedidos',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.darkGrey.withOpacity(0.5),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Sección de soporte
              _SettingsSection(
                title: '🆘 Soporte',
                children: [
                  _SettingsOption(
                    icon: Icons.help,
                    label: 'Ayuda y FAQs',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.darkGrey.withOpacity(0.5),
                    ),
                    onTap: () {},
                  ),
                  _SettingsOption(
                    icon: Icons.mail,
                    label: 'Contactar Soporte',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.darkGrey.withOpacity(0.5),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Botón de logout
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: CustomButton(
                  label: 'Cerrar Sesión',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Sesión cerrada'),
                        backgroundColor: AppTheme.primaryRed,
                        duration: const Duration(milliseconds: 1000),
                      ),
                    );
                  },
                  icon: Icons.logout,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Footer
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    Text(
                      'Barrio Napoli v1.0.0',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppTheme.darkGrey.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '© 2025 Todos los derechos reservados',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppTheme.darkGrey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [AppTheme.shadowSmall],
          ),
          child: Column(
            children: List.generate(
              children.length,
              (index) => Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Divider(
                      color: AppTheme.mediumGrey,
                      height: 1,
                      indent: AppTheme.spacingL,
                      endIndent: AppTheme.spacingM,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsOption({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryGreen,
      ),
      title: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
    );
  }
}

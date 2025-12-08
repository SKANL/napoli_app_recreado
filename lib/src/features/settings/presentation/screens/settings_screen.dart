import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/core/core_ui/theme_provider.dart';
import 'package:napoli_app_v1/src/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/screens/saved_addresses_screen.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/screens/purchase_history_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = ThemeProvider.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            _buildUserInfoSection(context, theme, l10n),
            const SizedBox(height: 24),

            // Configuración de la aplicación
            _buildAppSettingsSection(context, theme, themeController, l10n),
            const SizedBox(height: 24),

            // Preferencias
            _buildPreferencesSection(context, theme, l10n),
            const SizedBox(height: 24),

            // Ayuda y soporte
            _buildHelpSection(context, theme, l10n),
            const SizedBox(height: 24),

            // Cerrar sesión
            _buildLogoutSection(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar del usuario
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              'JD', // Iniciales del usuario
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nombre del usuario
          Text(
            'Juan Pérez', // TODO: Obtener del estado de usuario
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          // Email del usuario
          Text(
            'juan.perez@email.com', // TODO: Obtener del estado de usuario
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
            ),
          ),
          const SizedBox(height: 16),

          // Botón editar perfil
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.edit,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                l10n.editProfile,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(
    BuildContext context,
    ThemeData theme,
    themeController,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.appSettings,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha((0.05 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.dark_mode,
                title: l10n.darkMode,
                subtitle: l10n.darkModeSubtitle,
                trailing: Switch(
                  value: themeController.dark,
                  onChanged: (_) => themeController.toggle(),
                  activeTrackColor: theme.colorScheme.primary,
                ),
              ),
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.notifications,
                title: l10n.notifications,
                subtitle: l10n.notificationsSubtitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.language,
                title: l10n.language,
                subtitle: l10n.languageSubtitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  // TODO: Navegar a configuración de idioma
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoonLanguage)),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.preferences,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha((0.05 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.location_on,
                title: l10n.savedAddresses,
                subtitle: l10n.savedAddressesSubtitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedAddressesScreen(),
                    ),
                  );
                },
              ),
              // MÉTODOS DE PAGO - DESHABILITADO
              // TODO: Habilitar cuando el sistema de pagos con tarjeta esté listo
              // Descomentar el siguiente bloque para reactivar
              /*
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.payment,
                title: 'Métodos de Pago',
                subtitle: 'Gestionar tarjetas y métodos de pago',
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodsScreen(),
                    ),
                  );
                },
              ),
              */
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.history,
                title: l10n.purchaseHistory,
                subtitle: l10n.purchaseHistorySubtitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchaseHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpSupport,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha((0.05 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.help_outline,
                title: l10n.helpCenter,
                subtitle: l10n.helpCenterSubtitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  // TODO: Navegar a centro de ayuda
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.comingSoonHelp)));
                },
              ),
              _buildSettingsTile(
                context,
                theme,
                icon: Icons.info_outline,
                title: l10n.about,
                subtitle: l10n.version('1.0.0'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
                onTap: () {
                  _showAboutDialog(context, l10n);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildSettingsTile(
        context,
        theme,
        icon: Icons.logout,
        title: l10n.logout,
        subtitle: l10n.logoutSubtitle,
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.error),
        titleColor: theme.colorScheme.error,
        onTap: () {
          _showLogoutDialog(context, l10n);
        },
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: 'Napoli Pizza',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.local_pizza, size: 48),
      children: [
        Text(l10n.aboutDescription),
        const SizedBox(height: 16),
        Text(l10n.aboutFooter),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Cerrar configuración
              // TODO: Implementar lógica de logout real
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.sessionClosed)));
            },
            child: Text(
              l10n.logout,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/notification_settings/general_section.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/notification_settings/notification_types_section.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/notification_settings/quiet_hours_section.dart';
import 'package:napoli_app_v1/src/features/settings/presentation/widgets/notification_settings/sound_section.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Estados de las notificaciones
  bool _allNotifications = false; // Inicialmente desactivado
  bool _orderUpdates = false;
  bool _promotions = false;
  bool _newProducts = false;
  bool _deliveryReminders = false;
  bool _chatMessages = false;
  bool _weeklyOffers = false;
  bool _appUpdates = false;

  // Configuraciones de sonido y vibración
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _soundType = 'default';

  // Horarios de no molestar
  bool _quietHours = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);

  // Estado de permisos del sistema
  bool _systemPermissionGranted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.notifications,
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
            // Control general
            GeneralSection(
              allNotifications: _allNotifications,
              systemPermissionGranted: _systemPermissionGranted,
              onPermissionGranted: (value) =>
                  setState(() => _systemPermissionGranted = value),
              onChanged: (value) {
                if (value) {
                  _enableAllNotifications();
                } else {
                  _disableAllNotifications();
                }
              },
            ),
            const SizedBox(height: 24),

            // Tipos de notificaciones
            NotificationTypesSection(
              enabled: _allNotifications,
              orderUpdates: _orderUpdates,
              promotions: _promotions,
              newProducts: _newProducts,
              deliveryReminders: _deliveryReminders,
              chatMessages: _chatMessages,
              weeklyOffers: _weeklyOffers,
              appUpdates: _appUpdates,
              onOrderUpdatesChanged: (v) => setState(() => _orderUpdates = v),
              onPromotionsChanged: (v) => setState(() => _promotions = v),
              onNewProductsChanged: (v) => setState(() => _newProducts = v),
              onDeliveryRemindersChanged: (v) =>
                  setState(() => _deliveryReminders = v),
              onChatMessagesChanged: (v) => setState(() => _chatMessages = v),
              onWeeklyOffersChanged: (v) => setState(() => _weeklyOffers = v),
              onAppUpdatesChanged: (v) => setState(() => _appUpdates = v),
            ),
            const SizedBox(height: 24),

            // Configuración de sonido
            SoundSection(
              enabled: _allNotifications,
              soundEnabled: _soundEnabled,
              vibrationEnabled: _vibrationEnabled,
              soundType: _soundType,
              onSoundEnabledChanged: (v) => setState(() => _soundEnabled = v),
              onVibrationEnabledChanged: (v) =>
                  setState(() => _vibrationEnabled = v),
              onSoundTypeChanged: (v) => setState(() => _soundType = v),
            ),
            const SizedBox(height: 24),

            // Horarios de no molestar
            QuietHoursSection(
              enabled: _allNotifications,
              quietHoursEnabled: _quietHours,
              startTime: _quietHoursStart,
              endTime: _quietHoursEnd,
              onQuietHoursChanged: (v) => setState(() => _quietHours = v),
              onStartTimeChanged: (v) => setState(() => _quietHoursStart = v),
              onEndTimeChanged: (v) => setState(() => _quietHoursEnd = v),
            ),
            const SizedBox(height: 24),

            // Información adicional
            _buildInfoSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(
          (0.3 * 255).round(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.importantNotificationsInfo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.8 * 255).round(),
                ),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enableAllNotifications() {
    setState(() {
      _allNotifications = true;
      _orderUpdates = true;
      _promotions = true;
      _deliveryReminders = true;
      _chatMessages = true;
      _appUpdates = true;
      // Note: _systemPermissionGranted logic moved to GeneralSection callback
    });
  }

  void _disableAllNotifications() {
    setState(() {
      _allNotifications = false;
      _orderUpdates = false;
      _promotions = false;
      _newProducts = false;
      _deliveryReminders = false;
      _chatMessages = false;
      _weeklyOffers = false;
      _appUpdates = false;
    });
  }
}

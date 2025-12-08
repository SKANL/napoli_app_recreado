// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.notifications,
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
            _buildGeneralSection(theme),
            const SizedBox(height: 24),

            // Tipos de notificaciones
            _buildNotificationTypesSection(theme),
            const SizedBox(height: 24),

            // Configuración de sonido
            _buildSoundSection(theme),
            const SizedBox(height: 24),

            // Horarios de no molestar
            _buildQuietHoursSection(theme),
            const SizedBox(height: 24),

            // Información adicional
            _buildInfoSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.general,
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
              // Mensaje de permisos si no están otorgados
              if (!_systemPermissionGranted && !_allNotifications)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.permissionRequired,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _buildNotificationTile(
                theme,
                icon: Icons.notifications,
                title: AppLocalizations.of(context)!.allNotifications,
                subtitle: AppLocalizations.of(
                  context,
                )!.allNotificationsSubtitle,
                value: _allNotifications,
                onChanged: (value) async {
                  if (value && !_systemPermissionGranted) {
                    // Mostrar popup de permisos del sistema
                    final granted = await _showSystemPermissionDialog();
                    if (granted) {
                      _enableAllNotifications();
                    }
                  } else if (!value) {
                    _disableAllNotifications();
                  } else {
                    _enableAllNotifications();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTypesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.notificationTypes,
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
              _buildNotificationTile(
                theme,
                icon: Icons.delivery_dining,
                title: AppLocalizations.of(context)!.orderUpdates,
                subtitle: AppLocalizations.of(context)!.orderUpdatesSubtitle,
                value: _orderUpdates,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _orderUpdates = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.local_offer,
                title: AppLocalizations.of(context)!.promotions,
                subtitle: AppLocalizations.of(context)!.promotionsSubtitle,
                value: _promotions,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _promotions = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.new_releases,
                title: AppLocalizations.of(context)!.newProducts,
                subtitle: AppLocalizations.of(context)!.newProductsSubtitle,
                value: _newProducts,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _newProducts = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.schedule,
                title: AppLocalizations.of(context)!.deliveryReminders,
                subtitle: AppLocalizations.of(
                  context,
                )!.deliveryRemindersSubtitle,
                value: _deliveryReminders,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _deliveryReminders = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.chat,
                title: AppLocalizations.of(context)!.chatMessages,
                subtitle: AppLocalizations.of(context)!.chatMessagesSubtitle,
                value: _chatMessages,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _chatMessages = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.weekend,
                title: AppLocalizations.of(context)!.weeklyOffers,
                subtitle: AppLocalizations.of(context)!.weeklyOffersSubtitle,
                value: _weeklyOffers,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _weeklyOffers = value);
                      }
                    : null,
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.system_update,
                title: AppLocalizations.of(context)!.appUpdates,
                subtitle: AppLocalizations.of(context)!.appUpdatesSubtitle,
                value: _appUpdates,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _appUpdates = value);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.soundVibration,
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
              _buildNotificationTile(
                theme,
                icon: Icons.volume_up,
                title: AppLocalizations.of(context)!.sound,
                subtitle: AppLocalizations.of(context)!.soundSubtitle,
                value: _soundEnabled,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _soundEnabled = value);
                      }
                    : null,
              ),
              _buildSettingsTile(
                theme,
                icon: Icons.music_note,
                title: AppLocalizations.of(context)!.notificationTone,
                subtitle: _getSoundTypeName(context, _soundType),
                onTap: _allNotifications && _soundEnabled
                    ? () {
                        _showSoundPicker(theme);
                      }
                    : null,
                trailing: Icon(
                  Icons.chevron_right,
                  color: (_allNotifications && _soundEnabled)
                      ? theme.colorScheme.onSurface.withAlpha(
                          (0.5 * 255).round(),
                        )
                      : theme.colorScheme.onSurface.withAlpha(
                          (0.2 * 255).round(),
                        ),
                ),
              ),
              _buildNotificationTile(
                theme,
                icon: Icons.vibration,
                title: AppLocalizations.of(context)!.vibration,
                subtitle: AppLocalizations.of(context)!.vibrationSubtitle,
                value: _vibrationEnabled,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _vibrationEnabled = value);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuietHoursSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.doNotDisturb,
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
              _buildNotificationTile(
                theme,
                icon: Icons.do_not_disturb,
                title: AppLocalizations.of(context)!.quietHours,
                subtitle: AppLocalizations.of(context)!.quietHoursSubtitle,
                value: _quietHours,
                onChanged: _allNotifications
                    ? (value) {
                        setState(() => _quietHours = value);
                      }
                    : null,
              ),
              if (_quietHours && _allNotifications) ...[
                _buildSettingsTile(
                  theme,
                  icon: Icons.access_time,
                  title: AppLocalizations.of(context)!.startTime,
                  subtitle: _formatTime(_quietHoursStart),
                  onTap: () => _selectTime(true),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withAlpha(
                      (0.5 * 255).round(),
                    ),
                  ),
                ),
                _buildSettingsTile(
                  theme,
                  icon: Icons.access_time_filled,
                  title: AppLocalizations.of(context)!.endTime,
                  subtitle: _formatTime(_quietHoursEnd),
                  onTap: () => _selectTime(false),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withAlpha(
                      (0.5 * 255).round(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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

  Widget _buildNotificationTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    final isEnabled = onChanged != null;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled
              ? theme.colorScheme.primary.withAlpha((0.1 * 255).round())
              : theme.colorScheme.onSurface.withAlpha((0.05 * 255).round()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isEnabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isEnabled
              ? theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())
              : theme.colorScheme.onSurface.withAlpha((0.4 * 255).round()),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildSettingsTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Widget trailing,
  }) {
    final isEnabled = onTap != null;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled
              ? theme.colorScheme.primary.withAlpha((0.1 * 255).round())
              : theme.colorScheme.onSurface.withAlpha((0.05 * 255).round()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isEnabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isEnabled
              ? theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())
              : theme.colorScheme.onSurface.withAlpha((0.4 * 255).round()),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  String _getSoundTypeName(BuildContext context, String soundType) {
    switch (soundType) {
      case 'default':
        return AppLocalizations.of(context)!.defaultTone;
      case 'bell':
        return AppLocalizations.of(context)!.bellTone;
      case 'chime':
        return AppLocalizations.of(context)!.chimeTone;
      case 'notification':
        return AppLocalizations.of(context)!.notificationLabel;
      default:
        return AppLocalizations.of(context)!.defaultTone;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showSoundPicker(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.selectTone,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._getSoundOptions(context).map(
              (option) => ListTile(
                title: Text(option['name']!),
                leading: Radio<String>(
                  value: option['value']!,
                  groupValue: _soundType,
                  onChanged: (value) {
                    setState(() => _soundType = value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() => _soundType = option['value']!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getSoundOptions(BuildContext context) {
    return [
      {'name': AppLocalizations.of(context)!.defaultTone, 'value': 'default'},
      {'name': AppLocalizations.of(context)!.bellTone, 'value': 'bell'},
      {'name': AppLocalizations.of(context)!.chimeTone, 'value': 'chime'},
      {
        'name': AppLocalizations.of(context)!.notificationLabel,
        'value': 'notification',
      },
    ];
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _quietHoursStart : _quietHoursEnd,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        if (isStartTime) {
          _quietHoursStart = time;
        } else {
          _quietHoursEnd = time;
        }
      });
    }
  }

  // Métodos para gestionar permisos y estados
  Future<bool> _showSystemPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _SystemPermissionDialog(),
        ) ??
        false;
  }

  void _enableAllNotifications() {
    setState(() {
      _systemPermissionGranted = true;
      _allNotifications = true;
      _orderUpdates = true;
      _promotions = true;
      _deliveryReminders = true;
      _chatMessages = true;
      _appUpdates = true;
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

// Widget personalizado para simular el diálogo de permisos del sistema
class _SystemPermissionDialog extends StatefulWidget {
  @override
  State<_SystemPermissionDialog> createState() =>
      _SystemPermissionDialogState();
}

class _SystemPermissionDialogState extends State<_SystemPermissionDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    // Iniciar animaciones
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono de la app
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.local_pizza,
                        size: 32,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Título
                    Text(
                      '"Napoli Pizza" quiere enviarte notificaciones',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      'Las notificaciones pueden incluir alertas, sonidos e iconos de notificación.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'No permitir',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Permitir',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nota adicional
                    Text(
                      'Puedes cambiar esto en cualquier momento en Configuración',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
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

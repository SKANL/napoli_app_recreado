import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  List<AddressModel> addresses = [
    AddressModel(
      id: '1',
      label: 'Casa',
      address: 'Calle Principal 123, Col. Centro',
      city: 'Ciudad de México',
      details: 'Casa blanca con portón negro',
      isDefault: true,
    ),
    AddressModel(
      id: '2',
      label: 'Trabajo',
      address: 'Av. Reforma 456, Piso 8',
      city: 'Ciudad de México',
      details: 'Oficina 804, Torre B',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.savedAddresses,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: addresses.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(context, theme, address, index);
              },
            ),
      floatingActionButton: addresses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddAddressDialog(context),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: const Icon(Icons.add_location),
              label: Text(AppLocalizations.of(context)!.addAddress),
            )
          : null,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noSavedAddresses,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noSavedAddressesDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddAddressDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_location),
              label: Text(AppLocalizations.of(context)!.addFirstAddress),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    ThemeData theme,
    AddressModel address,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header con etiqueta y acciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: address.isDefault
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                // Icono de etiqueta
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getLabelColor(
                      address.label,
                      theme,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getLabelIcon(address.label),
                    color: _getLabelColor(address.label, theme),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Etiqueta y estado
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.defaultLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Menú de opciones
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleAddressAction(value, address, index),
                  itemBuilder: (context) => [
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 20),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.setAsDefault),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.delete,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Información de la dirección
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.address,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            address.city,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (address.details.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address.details,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'casa':
      case 'home':
        return Icons.home;
      case 'trabajo':
      case 'work':
        return Icons.work;
      case 'universidad':
      case 'uni':
      case 'escuela':
        return Icons.school;
      case 'gimnasio':
        return Icons.fitness_center;
      case 'familia':
        return Icons.family_restroom;
      case 'amigos':
        return Icons.people;
      case 'otro':
      case 'other':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  Color _getLabelColor(String label, ThemeData theme) {
    switch (label.toLowerCase()) {
      case 'casa':
      case 'home':
        return Colors.green;
      case 'trabajo':
      case 'work':
        return Colors.blue;
      case 'universidad':
      case 'uni':
      case 'escuela':
        return Colors.purple;
      case 'gimnasio':
        return Colors.orange;
      case 'familia':
        return Colors.pink;
      case 'amigos':
        return Colors.teal;
      case 'otro':
      case 'other':
        return Colors.grey;
      default:
        return theme.colorScheme.primary;
    }
  }

  void _handleAddressAction(String action, AddressModel address, int index) {
    switch (action) {
      case 'default':
        _setAsDefault(index);
        break;
      case 'edit':
        _showEditAddressDialog(context, address, index);
        break;
      case 'delete':
        _showDeleteConfirmation(context, address, index);
        break;
    }
  }

  void _setAsDefault(int index) {
    setState(() {
      // Quitar predeterminada actual
      for (var addr in addresses) {
        addr.isDefault = false;
      }
      // Establecer nueva predeterminada
      addresses[index].isDefault = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.addressSetAsDefault(addresses[index].label),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AddressModel address,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAddressTitle),
        content: Text(
          AppLocalizations.of(
            context,
          )!.deleteAddressConfirmation(address.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.addressDeleted(address.label),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    _showAddressFormDialog(context, null, null);
  }

  void _showEditAddressDialog(
    BuildContext context,
    AddressModel address,
    int index,
  ) {
    _showAddressFormDialog(context, address, index);
  }

  void _showAddressFormDialog(
    BuildContext context,
    AddressModel? address,
    int? index,
  ) {
    final isEditing = address != null;
    final labelController = TextEditingController(text: address?.label ?? '');
    final addressController = TextEditingController(
      text: address?.address ?? '',
    );
    final cityController = TextEditingController(text: address?.city ?? '');
    final detailsController = TextEditingController(
      text: address?.details ?? '',
    );

    bool isDefault = address?.isDefault ?? addresses.isEmpty;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            isEditing
                ? AppLocalizations.of(context)!.editAddressTitle
                : AppLocalizations.of(context)!.addAddressTitle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Etiqueta
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.labelLabel,
                    hintText: AppLocalizations.of(context)!.labelHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Dirección
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.addressLabel,
                    hintText: AppLocalizations.of(context)!.addressHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Ciudad
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.cityLabel,
                    hintText: AppLocalizations.of(context)!.cityHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Detalles adicionales
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.detailsLabel,
                    hintText: AppLocalizations.of(context)!.detailsHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Hacer predeterminada
                CheckboxListTile(
                  title: Text(AppLocalizations.of(context)!.setAsDefaultLabel),
                  value: isDefault,
                  onChanged: (value) {
                    setDialogState(() {
                      isDefault = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (labelController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    cityController.text.isNotEmpty) {
                  final newAddress = AddressModel(
                    id:
                        address?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    label: labelController.text,
                    address: addressController.text,
                    city: cityController.text,
                    details: detailsController.text,
                    isDefault: isDefault,
                  );

                  setState(() {
                    if (isDefault) {
                      // Quitar predeterminada actual
                      for (var addr in addresses) {
                        addr.isDefault = false;
                      }
                    }

                    if (isEditing && index != null) {
                      addresses[index] = newAddress;
                    } else {
                      addresses.add(newAddress);
                    }
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? AppLocalizations.of(context)!.addressUpdated
                            : AppLocalizations.of(context)!.addressAdded,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(
                isEditing
                    ? AppLocalizations.of(context)!.updateAction
                    : AppLocalizations.of(context)!.addAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo para las direcciones
class AddressModel {
  final String id;
  final String label;
  final String address;
  final String city;
  final String details;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.details,
    required this.isDefault,
  });
}

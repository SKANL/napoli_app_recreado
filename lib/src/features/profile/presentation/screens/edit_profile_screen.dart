import 'package:flutter/material.dart';
import 'package:napoli_app_v1/l10n/arb/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:napoli_app_v1/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:napoli_app_v1/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:napoli_app_v1/src/features/auth/data/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isUpdating = false;
  String? _selectedImagePath;
  bool _hasPhotoPermissions = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final state = context.read<AuthCubit>().state;
    if (state is Authenticated) {
      final user = state.user;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      if (user.photoUrl != null) {
        setState(() {
          _selectedImagePath = user.photoUrl;
          _hasPhotoPermissions = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is Authenticated && _isUpdating) {
          _isUpdating = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileUpdated),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.editProfile,
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
            actions: [
              TextButton(
                onPressed: isLoading ? null : _saveProfile,
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    color: isLoading
                        ? theme.colorScheme.onSurface.withAlpha(
                            (0.5 * 255).round(),
                          )
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar del usuario
                  _buildAvatarSection(theme, l10n),
                  const SizedBox(height: 32),

                  // Formulario
                  _buildFormSection(theme, l10n),
                  const SizedBox(height: 32),

                  // Botón de guardar
                  _buildSaveButton(theme, l10n, isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary,
              child: _buildAvatarContent(theme, l10n),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () async {
            if (!_hasPhotoPermissions) {
              final granted = await _showPhotoPermissionDialog(l10n);
              if (granted) {
                _showPhotoOptionsDialog(l10n);
              }
            } else {
              _showPhotoOptionsDialog(l10n);
            }
          },
          icon: Icon(Icons.edit, size: 18, color: theme.colorScheme.primary),
          label: Text(
            l10n.changePhoto,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent(ThemeData theme, AppLocalizations l10n) {
    // Si hay una imagen seleccionada, mostrar simulación
    if (_selectedImagePath != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 32, color: theme.colorScheme.onPrimary),
              Text(
                l10n.photo,
                style: TextStyle(
                  fontSize: 8,
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Por defecto mostrar iniciales
    return Text(
      'JP', // Iniciales por defecto
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildFormSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.personalInfo,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Nombre completo
        _buildTextField(
          controller: _nameController,
          label: l10n.fullName,
          icon: Icons.person,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.nameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email
        _buildTextField(
          controller: _emailController,
          label: l10n.email,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.emailRequired;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return l10n.emailInvalid;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Teléfono
        _buildTextField(
          controller: _phoneController,
          label: l10n.phone,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.phoneRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Dirección
        _buildTextField(
          controller: _addressController,
          label: l10n.address,
          icon: Icons.location_on,
          maxLines: 2,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.addressRequired;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha((0.5 * 255).round()),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
    );
  }

  Widget _buildSaveButton(
    ThemeData theme,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                l10n.saveChanges,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _isUpdating = true;

    final user = UserModel(
      id: 'current_user', // ID should come from current user but for now we update the singleton
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      photoUrl: _selectedImagePath,
    );

    context.read<AuthCubit>().updateProfile(user);
  }

  // Métodos para manejo de permisos y selección de fotos
  Future<bool> _showPhotoPermissionDialog(AppLocalizations l10n) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _PhotoPermissionDialog(l10n: l10n),
        ) ??
        false;
  }

  void _showPhotoOptionsDialog(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PhotoOptionsBottomSheet(
        l10n: l10n,
        onPhotoSelected: (imagePath) {
          setState(() {
            setState(() {
              _hasPhotoPermissions = true;
              _selectedImagePath = imagePath.isEmpty ? null : imagePath;
            });
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

// Widget para el diálogo de permisos de fotos
class _PhotoPermissionDialog extends StatefulWidget {
  final AppLocalizations l10n;
  const _PhotoPermissionDialog({required this.l10n});

  @override
  State<_PhotoPermissionDialog> createState() => _PhotoPermissionDialogState();
}

class _PhotoPermissionDialogState extends State<_PhotoPermissionDialog>
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

    _scaleController.forward();
    _slideController.forward();
  }

  @override
  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;

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
                        Icons.photo_camera,
                        size: 32,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Título
                    Text(
                      l10n.photoPermissionTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      l10n.photoPermissionDesc,
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
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.deny,
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
                            onPressed: () => Navigator.of(context).pop(true),
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
                              l10n.allow,
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
                      l10n.photoPermissionNote,
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

// Widget para las opciones de foto
class _PhotoOptionsBottomSheet extends StatelessWidget {
  final Function(String) onPhotoSelected;
  final AppLocalizations l10n;

  const _PhotoOptionsBottomSheet({
    required this.onPhotoSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              Icon(Icons.photo_camera, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                l10n.changeProfilePhoto,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Opciones de cámara y galería
          _buildOptionTile(
            theme,
            icon: Icons.camera_alt,
            title: l10n.takePhoto,
            subtitle: l10n.takePhotoSubtitle,
            onTap: () => _simulatePhotoCapture(context, l10n),
          ),
          _buildOptionTile(
            theme,
            icon: Icons.photo_library,
            title: l10n.chooseGallery,
            subtitle: l10n.chooseGallerySubtitle,
            onTap: () => _simulateGallerySelection(context, l10n),
          ),

          // Opción para quitar foto actual (si existe)
          _buildOptionTile(
            theme,
            icon: Icons.person_outline,
            title: l10n.useInitials,
            subtitle: l10n.useInitialsSubtitle,
            onTap: () => _removePhoto(context, l10n),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 24),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }

  void _simulatePhotoCapture(BuildContext context, AppLocalizations l10n) {
    // Simular captura de foto con éxito
    onPhotoSelected('camera_photo_${DateTime.now().millisecondsSinceEpoch}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.photoCaptured),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simulateGallerySelection(BuildContext context, AppLocalizations l10n) {
    // Simular selección de galería con éxito
    onPhotoSelected('gallery_photo_${DateTime.now().millisecondsSinceEpoch}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.photoSelected),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removePhoto(BuildContext context, AppLocalizations l10n) {
    // Quitar foto actual y volver a iniciales
    onPhotoSelected('');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.person, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.usingInitials),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

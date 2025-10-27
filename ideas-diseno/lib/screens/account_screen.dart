import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Mi Cuenta',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildSectionTitle('General'),
          _buildOptionTile(
            icon: Icons.person_outline,
            title: 'Editar Perfil',
            onTap: () {},
          ),
          _buildOptionTile(
            icon: Icons.receipt_long_outlined,
            title: 'Historial de Pedidos',
            onTap: () {},
          ),
          _buildOptionTile(
            icon: Icons.location_on_outlined,
            title: 'Direcciones Guardadas',
            onTap: () {},
          ),
          _buildOptionTile(
            icon: Icons.payment_outlined,
            title: 'Métodos de Pago',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Ajustes'),
          _buildOptionTile(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            onTap: () {},
          ),
          _buildOptionTile(
            icon: Icons.help_outline,
            title: 'Ayuda y Soporte',
            onTap: () {},
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                'Cerrar Sesión',
                style: GoogleFonts.roboto(
                  color: const Color(0xFFB53229),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFF1B5E20),
            child: Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usuario de Prueba',
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'usuario@email.com',
                style:
                    GoogleFonts.roboto(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.roboto(
            color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildOptionTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1B5E20)),
        title: Text(title, style: GoogleFonts.roboto(fontSize: 16)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

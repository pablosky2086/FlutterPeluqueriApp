import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peluqueriapp/providers/cliente_form_provider.dart';
import 'package:flutter_peluqueriapp/providers/auth_provider.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientFormProvider(),
      child: const _ClientContent(),
    );
  }
}

class _ClientContent extends StatelessWidget {
  const _ClientContent();

  // Función para mostrar el Pop-up de confirmación
  void _mostrarAlertaLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Cerrar Sesión"),
          content: const Text("¿Estás seguro de que quieres salir de la aplicación?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cerrar popup (Cancelar)
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // 1. Cerrar la alerta primero
                Navigator.of(context).pop();
                
                // 2. Llamar al logout del Provider (Limpia datos y cambia estado)
                Provider.of<AuthProvider>(context, listen: false).logout();
                
                // 3. ⭐ LA SOLUCIÓN: Limpiar la navegación
                // Esto cierra la pantalla de Clientes (y cualquier otra) hasta volver a la base.
                // Como tu MainApp ya cambió la base a LoginScreen, aparecerás ahí.
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.orangeAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientForm = Provider.of<ClientFormProvider>(context);

    // Spinner de carga mientras trae los datos
    if (clientForm.isLoading && clientForm.nameCtrl.text.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        // Flecha de volver (automática) en color naranja
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        
        // BOTÓN ÚNICO DE LOGOUT (Arriba a la derecha)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _mostrarAlertaLogout(context),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: clientForm.formKey,
            child: Column(
              children: [
                // FOTO DE PERFIL
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                      backgroundImage: const AssetImage("assets/profile.jpg"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // CAMPOS
                _buildCompactTextField(
                  controller: clientForm.nameCtrl,
                  label: "Nombre Completo",
                  icon: Icons.person,
                  validator: (val) => (val == null || val.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),

                _buildCompactTextField(
                  controller: clientForm.phoneCtrl,
                  label: "Teléfono",
                  icon: Icons.phone,
                  keyboard: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                _buildCompactTextField(
                  controller: clientForm.emailCtrl,
                  label: "Email",
                  icon: Icons.email,
                  enabled: false,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: clientForm.observationsCtrl,
                  decoration: _inputDecoration("Observaciones", Icons.notes),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: clientForm.allergiesCtrl,
                  decoration: _inputDecoration("Alergias", Icons.warning_amber_rounded),
                  maxLines: 2,
                ),

                const SizedBox(height: 30),

                // BOTÓN GUARDAR (El único botón grande)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: clientForm.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            final success = await clientForm.updateClient();
                            if (!context.mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Perfil actualizado correctamente")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al guardar cambios"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    child: Text(
                      clientForm.isLoading ? "Guardando..." : "Guardar Cambios",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                // HE ELIMINADO EL BOTÓN DE LOGOUT QUE ESTABA AQUÍ ABAJO
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboard,
      validator: validator,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.orangeAccent),
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/services/cliente_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClienteService clienteService = ClienteService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alergiasController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();

  // Estado de carga inicial de datos
  bool isLoading = true;
  int? userId;

  // Cargar datos del cliente al iniciar el estado
  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id');
    final clienteInfo = await clienteService.getClienteInfo(userId!);
    if (clienteInfo != null) {
      setState(() {
        nameController.text = clienteInfo['nombreCompleto'] ?? '';
        phoneController.text = clienteInfo['telefono'] ?? '';
        emailController.text = clienteInfo['email'] ?? '';
        alergiasController.text = clienteInfo['alergenos'] ?? '';
        observacionesController.text = clienteInfo['observaciones'] ?? '';
        isLoading = false;
      });
    } else {
      // Manejar el error de carga de datos
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> guardarCambios() async {
    if (userId == null) return;

    final payload = {
      "nombreCompleto": nameController.text,
      "telefono": phoneController.text,
      "email": emailController.text,
      "alergenos": alergiasController.text,
      "observaciones": observacionesController.text,
    };

    final success = await clienteService.updateCliente(userId!, payload);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Cambios guardados correctamente"
              : "Error al guardar cambios",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Perfil del Cliente",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 20),

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
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // CAMPOS DE TEXTO Y DROPDOWN
                  _buildCompactTextField(
                    nameController,
                    "Nombre",
                    Icons.person,
                  ),
                  const SizedBox(height: 10),
                  _buildCompactTextField(
                    phoneController,
                    "Teléfono",
                    Icons.phone,
                    keyboard: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  _buildCompactTextField(
                    emailController,
                    "Email",
                    Icons.email,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),

                  // Alergias
                  TextField(
                    controller: observacionesController, // ← IMPORTANTE
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.notes, color: Colors.orangeAccent),
                      labelText: "Observaciones",
                      hintText: "Notas sobre el cliente, preferencias…",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 10),

                  // Observaciones
                  TextField(
                    controller: alergiasController, // ← IMPORTANTE
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orangeAccent,
                      ),
                      labelText: "Alergias",
                      hintText: "Ej: Penicilina, látex, frutos secos…",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 20),

                  // BOTÓN GUARDAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4B95B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: guardarCambios,
                      /*onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Cambios guardados")),
                        );
                      },*/
                      child: const Text("Guardar cambios"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 15),
    );
  }
}

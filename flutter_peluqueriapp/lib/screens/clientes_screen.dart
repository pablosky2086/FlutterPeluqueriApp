import 'package:flutter/material.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil / Cliente"),
        backgroundColor: const Color(0xFFF4B95B),
      ),
      body: const Center(
        child: Text("Pantalla de perfil o clientes"),
      ),
    );
  }
}

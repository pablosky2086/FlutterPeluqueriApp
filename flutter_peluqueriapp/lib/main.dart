import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Cargar environment variables
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Aquí puedes agregar tus providers si los tienes
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MaterialApp(
        title: 'PeluqueriApp',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}

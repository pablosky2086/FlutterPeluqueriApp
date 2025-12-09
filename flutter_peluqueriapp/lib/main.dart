import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Cargar environment variables
  WidgetsFlutterBinding.ensureInitialized();
  // STATUS BAR ÍCONOS OSCUROS (modo light)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Fondo transparente o del color de tu app
      statusBarIconBrightness: Brightness.dark, // Iconos oscuros (Android)
      statusBarBrightness: Brightness.light, // Iconos oscuros (iOS)
    ),
  );

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
        locale: const Locale('es'),
        supportedLocales: const [Locale('es'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: LoginScreen(),
      ),
    );
  }
}

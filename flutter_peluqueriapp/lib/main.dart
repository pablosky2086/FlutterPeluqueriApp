import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_peluqueriapp/screens/menu_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_peluqueriapp/providers/auth_provider.dart';

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
        // Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'PeluqueriApp',
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        supportedLocales: const [Locale('es'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Consumer<AuthProvider>(
          builder: (_, auth, __) {
            if (auth.status == AuthStatus.checking) {
              print('Checking auth status...');
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (auth.status == AuthStatus.authenticated) {
              print('User is authenticated, navigating to MenuScreen...');
              return const MenuScreen();
            } else {
              print('User is not authenticated, navigating to LoginScreen...');
              return const LoginScreen();
            } 
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _initializeData(); 
  }

  Future<void> _initializeData() async {
    await Future.delayed(const Duration(seconds: 1));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App Peluquería',
      home: Scaffold(
        body: Center(
          child: Text("App cargada"),
        ),
      ),
    );
  }
}

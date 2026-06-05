import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.init();

  runApp(const ZindasicApp());
}

class ZindasicApp extends StatelessWidget {
  const ZindasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zindasic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        fontFamily: 'Gilroy',
      ),
      home: const SplashScreen(),
    );
  }
}

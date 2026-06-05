import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasOnboarded = prefs.getBool('has_onboarded') ?? false;

  runApp(ZindasicApp(showLogin: !hasOnboarded));
}

class ZindasicApp extends StatelessWidget {
  final bool showLogin;
  const ZindasicApp({super.key, required this.showLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zindasic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        fontFamily: 'Gilroy',
      ),
      home: showLogin ? _LoginGate() : const HomeScreen(),
    );
  }
}

class _LoginGate extends StatefulWidget {
  @override
  State<_LoginGate> createState() => _LoginGateState();
}

class _LoginGateState extends State<_LoginGate> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      onLoginComplete: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder: (context, anim, secondaryAnimation, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}

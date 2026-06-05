import 'dart:async';
import 'package:flutter/material.dart';
import 'main_navigation_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasTransitioned = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller for a smooth fade-in
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start fade-in animation
    _animationController.forward().then((_) {
      // Hold the image fully visible for 1 second, then transition to home dashboard
      Timer(const Duration(milliseconds: 1000), () {
        _transitionToHome();
      });
    });
  }

  void _transitionToHome() {
    if (_hasTransitioned) return;
    _hasTransitioned = true;
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainNavigationLayout(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox.expand(
            child: Image.asset(
              'public/splash.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

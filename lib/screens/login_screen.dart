import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../utils/image_resizer.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginComplete;

  const LoginScreen({super.key, required this.onLoginComplete});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedImageBase64;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      try {
        final rawBytes = await picked.readAsBytes();
        // Resize image bytes to 200x200 standard PNG via browser/native Canvas
        final resizedBytes = await resizeImageFile(
          picked.path,
          rawBytes,
          200,
          200,
        );
        final base64String = base64Encode(resizedBytes);
        setState(() {
          _selectedImageBase64 = base64String;
          _errorMessage = null;
        });
      } catch (e) {
        setState(() => _errorMessage = 'Failed to read image');
      }
    }
  }

  Future<void> _handleBeginListening() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      if (_selectedImageBase64 != null) {
        try {
          await prefs.setString('user_image_path', _selectedImageBase64!);
        } catch (e) {
          debugPrint('Failed to save profile picture persistently (quota limit): $e');
        }
      }
      await prefs.setBool('has_onboarded', true);

      appState.login(name, _selectedImageBase64 ?? '');

      if (mounted) {
        widget.onLoginComplete();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blurred background hint (the home screen bg)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1.0],
                colors: [Color(0xFF1E1E1E), Color(0xFF2F5651)],
              ),
            ),
          ),

          // Dimmed overlay
          Container(color: Colors.black.withValues(alpha: 0.45)),

          // Modal card — centered
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A).withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF384F4A).withValues(alpha: 0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Image.asset(
                        'public/logo.png',
                        height: 41,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      // Welcome heading
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "The songs are ready, now tell us who's listening",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Name input
                      _InputField(
                        controller: _nameController,
                        hintText: 'type your name here',
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      // Image picker field
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFD9D9D9,
                            ).withValues(alpha: 0.74),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_selectedImageBase64 != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(_selectedImageBase64!),
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.person, size: 28, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'image selected ✓',
                                  style: TextStyle(
                                    color: Color(0xFF0F7C72),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ] else
                                const Text(
                                  'insert your image',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFE05252),
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Begin listening button
                      Center(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleBeginListening,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 160,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? const Color(
                                      0xFF0F7C72,
                                    ).withValues(alpha: 0.6)
                                  : const Color(0xFF0F7C72),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'begin listening',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
        ],
      ),
    );
  }
}

// ── Reusable input field ──────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w800,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        cursorColor: const Color(0xFF0F7C72),
      ),
    );
  }
}


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperContactButton extends StatefulWidget {
  const DeveloperContactButton({super.key});

  @override
  State<DeveloperContactButton> createState() => _DeveloperContactButtonState();
}

class _DeveloperContactButtonState extends State<DeveloperContactButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOverlayOpen = false;

  void _toggleOverlay() {
    if (_isOverlayOpen) {
      _closeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOverlayOpen = true;
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss overlay when tapping anywhere outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeOverlay,
              child: Container(),
            ),
          ),
          // Positioned glass pill below target icon
          Positioned(
            width: 150,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              // Align the right edge of the button with the right edge of the laptop icon
              offset: Offset(-150 + size.width, size.height + 8),
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () async {
                    _closeOverlay();
                    final Uri url = Uri.parse('https://linkedin.com/in/aaditajay');
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      debugPrint('Could not launch LinkedIn URL: $e');
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: const Text(
                          'Contact Developer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w400,
                          ),
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

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: const Icon(
          Icons.laptop,
          color: Color(0xFF1AFBE5),
          size: 24,
        ),
      ),
    );
  }
}

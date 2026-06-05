import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';

class ZindasicLogo extends StatelessWidget {
  final double size;
  final double fontSize;
  final bool showText;
  final Color? iconColor;

  const ZindasicLogo({
    super.key,
    this.size = 36,
    this.fontSize = 20,
    this.showText = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoCircle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0E7C7B), // Active turquoise
            Color(0xFF1A3E39), // Darker teal
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E7C7B).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'ज़ी',
        style: GoogleFonts.rozhaOne(
          color: iconColor ?? Colors.white,
          fontSize: size * 0.55,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (!showText) return logoCircle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoCircle,
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'zindasic',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                height: 1.1,
              ),
            ),
            Text(
              "favorites' favorites",
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFB0BDBA),
                fontSize: fontSize * 0.42,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../models/song.dart';

class SongArtwork extends StatelessWidget {
  final Song song;
  final double? width;
  final double? height;
  final double radius;
  final bool showEditorialText;

  const SongArtwork({
    super.key,
    required this.song,
    this.width,
    this.height,
    this.radius = 6,
    this.showEditorialText = true,
  });

  static const _palettes = [
    [Color(0xFF19FBE5), Color(0xFF143832), Color(0xFFFAE17A)],
    [Color(0xFF7CFFCB), Color(0xFF17213A), Color(0xFF8A6BFF)],
    [Color(0xFFFFE6A3), Color(0xFF31151D), Color(0xFFBA274A)],
    [Color(0xFFDBF8FF), Color(0xFF173242), Color(0xFFFF7A59)],
    [Color(0xFFA8FF78), Color(0xFF111E18), Color(0xFFFFC857)],
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[(int.tryParse(song.id) ?? 1) % _palettes.length];

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [palette[1], palette[0]],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -28,
                right: -22,
                child: _VinylRing(color: palette[2].withValues(alpha: 0.85)),
              ),
              Positioned(
                left: -40,
                bottom: -36,
                child: _VinylRing(color: Colors.black.withValues(alpha: 0.32)),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.62),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              if (showEditorialText)
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        song.personName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: palette[2],
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarBadge extends StatelessWidget {
  final String name;
  final String seed;
  final double size;

  const AvatarBadge({
    super.key,
    required this.name,
    required this.seed,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final hash = seed.codeUnits.fold<int>(0, (value, unit) => value + unit);
    final hue = (hash % 360).toDouble();
    final primary = HSLColor.fromAHSL(1, hue, 0.58, 0.58).toColor();
    final secondary = HSLColor.fromAHSL(
      1,
      (hue + 42) % 360,
      0.62,
      0.22,
    ).toColor();
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _VinylRing extends StatelessWidget {
  final Color color;

  const _VinylRing({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 22),
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ),
      ),
    );
  }
}

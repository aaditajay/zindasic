import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LiquidGlass — drop-in BackdropFilter widget that mimics the liquid-glass
// distortion from the reference SVG filter (feTurbulence + feDisplacementMap).
//
// Flutter can't run SVG filters natively, but we layer four effects to get
// the same visual read:
//   1. ImageFilter.blur  — frosted base
//   2. Tinted overlay    — teal-white tint at low opacity (depth)
//   3. Inner highlight   — top-edge shimmer (refraction glint)
//   4. Inner shadow      — bottom-edge dark rim (glass thickness)
//
// Use [LiquidGlassContainer] as a direct replacement wherever you currently
// have a plain BackdropFilter / Container with opacity.
// ─────────────────────────────────────────────────────────────────────────────

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double blurStrength;
  final Color tintColor;
  final double tintOpacity;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.blurStrength = 18,
    this.tintColor = const Color(0xFF2F5651),
    this.tintOpacity = 0.28,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // ① Blur layer — the core frosted glass
            BackdropFilter(
              filter: ImageFilter.compose(
                outer: ImageFilter.blur(
                  sigmaX: blurStrength,
                  sigmaY: blurStrength,
                  tileMode: TileMode.mirror,
                ),
                // subtle matrix shift adds the "displacement" warmth
                inner: ColorFilter.matrix(<double>[
                  1.02, 0,    0,    0, 2,
                  0,    1.02, 0,    0, 2,
                  0,    0,    1.04, 0, 4,
                  0,    0,    0,    1, 0,
                ]),
              ),
              child: const SizedBox.expand(),
            ),

            // ② Tint layer — gives the teal-glass colour cast
            Container(
              decoration: BoxDecoration(
                color: tintColor.withOpacity(tintOpacity),
              ),
            ),

            // ③ Noise-texture overlay — simulates the turbulence grain
            //    We approximate it with a very subtle radial gradient
            //    shifting from white→transparent, offset to one corner.
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -0.7),
                  radius: 1.4,
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // ④ Top highlight — the bright refraction glint at the top edge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: borderRadius.topLeft,
                    topRight: borderRadius.topRight,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.55),
                      Colors.white.withOpacity(0.10),
                    ],
                  ),
                ),
              ),
            ),

            // ⑤ Bottom shadow rim — glass thickness illusion
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: borderRadius.bottomLeft,
                    bottomRight: borderRadius.bottomRight,
                  ),
                  color: Colors.black.withOpacity(0.18),
                ),
              ),
            ),

            // ⑥ Border stroke — inset ring like inset box-shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 1,
                ),
              ),
            ),

            // ⑦ Actual content on top
            if (padding != null)
              Padding(padding: padding!, child: child)
            else
              child,
          ],
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// MINI PLAYER  — replace your existing mini-player Container with this
// ─────────────────────────────────────────────────────────────────────────────

class GlassMiniPlayer extends StatelessWidget {
  final String songTitle;
  final String artistName;
  final ImageProvider? albumArt;
  final bool isPlaying;
  final bool isShuffle;
  final VoidCallback onPlayPause;
  final VoidCallback onShuffle;
  final VoidCallback onQuote;
  final VoidCallback? onTap;

  const GlassMiniPlayer({
    super.key,
    required this.songTitle,
    required this.artistName,
    this.albumArt,
    required this.isPlaying,
    required this.isShuffle,
    required this.onPlayPause,
    required this.onShuffle,
    required this.onQuote,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.circular(16),
          blurStrength: 20,
          tintColor: const Color(0xFF1A3530),
          tintOpacity: 0.55,
          height: 58,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: albumArt != null
                      ? Image(
                          image: albumArt!,
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 38,
                          height: 38,
                          color: const Color(0xFF0F7C72).withValues(alpha: 0.4),
                          child: const Icon(Icons.music_note,
                              color: Colors.white54, size: 18),
                        ),
                ),
                const SizedBox(width: 10),

                // Song info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        artistName,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Controls
                _GlassIconButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: onQuote,
                ),
                const SizedBox(width: 4),
                _GlassIconButton(
                  icon: Icons.shuffle_rounded,
                  onTap: onShuffle,
                  color: isShuffle
                      ? const Color(0xFF1AFBE5)
                      : Colors.white.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 4),
                _GlassIconButton(
                  icon: isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  onTap: onPlayPause,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV BAR  — replace your existing bottom nav with this
// ─────────────────────────────────────────────────────────────────────────────

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.people_alt_outlined, label: 'People'),
    (icon: Icons.menu_book_outlined, label: 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 4,
      ),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(24),
        blurStrength: 22,
        tintColor: const Color(0xFF1A3530),
        tintOpacity: 0.60,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: selected
                    ? BoxDecoration(
                        // The selected pill — its own inner glass layer
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withOpacity(0.12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F7C72).withOpacity(0.25),
                            blurRadius: 10,
                            spreadRadius: -2,
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.45),
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white.withOpacity(0.45),
                        fontSize: 10,
                        fontFamily: 'Gilroy',
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// SMALL HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color ?? Colors.white.withValues(alpha: 0.85), size: size),
    );
  }
}
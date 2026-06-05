import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/developer_contact_button.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  Widget _buildHeader(BuildContext context) {
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
    final Animation<double> routeAnimation = modalRoute?.animation ?? const AlwaysStoppedAnimation(1.0);

    final Animation<double> laptopOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: routeAnimation,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    final Animation<double> arrowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: routeAnimation,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 23, 22, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'public/logo.png',
            height: 65,
            fit: BoxFit.contain,
          ),
          // Animated header icon: cross-fades between DeveloperContactButton and Down Arrow
          AnimatedBuilder(
            animation: routeAnimation,
            builder: (context, _) {
              return SizedBox(
                width: 28,
                height: 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Laptop icon (DeveloperContactButton) fading out
                    Opacity(
                      opacity: laptopOpacity.value,
                      child: IgnorePointer(
                        ignoring: laptopOpacity.value < 0.5,
                        child: const DeveloperContactButton(),
                      ),
                    ),
                    // Down arrow icon fading in
                    Opacity(
                      opacity: arrowOpacity.value,
                      child: IgnorePointer(
                        ignoring: arrowOpacity.value < 0.5,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.expand_more,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeekbar() {
    return StreamBuilder<Duration?>(
      stream: appState.audioPlayer.durationStream,
      builder: (context, durationSnapshot) {
        final duration = durationSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: appState.audioPlayer.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final maxVal = duration.inMilliseconds.toDouble();
            final currentVal = position.inMilliseconds
                .clamp(0, duration.inMilliseconds)
                .toDouble();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 6.5,
                        elevation: 0,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 0,
                      ),
                    ),
                    child: Slider(
                      value: maxVal > 0 ? currentVal : 0.0,
                      max: maxVal > 0 ? maxVal : 1.0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withValues(alpha: 0.3),
                      onChanged: (value) {
                        appState.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.71),
                          fontSize: 15,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.71),
                          fontSize: 15,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          IconButton(
            icon: Icon(
              Icons.shuffle,
              color: appState.isShuffle ? const Color(0xFF1AFBE5) : Colors.white,
              size: 24,
            ),
            onPressed: () {
              appState.toggleShuffle();
            },
          ),

          // Previous
          IconButton(
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              appState.playPrevious();
            },
          ),

          // Play/Pause (large)
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(
                appState.isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF1E1E1E),
                size: 32,
              ),
              onPressed: () {
                appState.togglePlay();
              },
            ),
          ),

          // Next
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 24),
            onPressed: () {
              appState.playNext();
            },
          ),

          // Repeat
          IconButton(
            icon: Icon(
              Icons.repeat,
              color: appState.isRepeat ? const Color(0xFF1AFBE5) : Colors.white,
              size: 24,
            ),
            onPressed: () {
              appState.toggleRepeat();
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
    final Animation<double> routeAnimation = modalRoute?.animation ?? const AlwaysStoppedAnimation(1.0);

    // Highly optimized Cubic curve resembling easeOutExpo for buttery smooth entrance
    final CurvedAnimation slideCurve = CurvedAnimation(
      parent: routeAnimation,
      curve: const Cubic(0.19, 1.0, 0.22, 1.0),
      reverseCurve: const Cubic(0.19, 1.0, 0.22, 1.0).flipped,
    );

    final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(slideCurve);

    final Animation<double> headerBgOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: routeAnimation,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    ));

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final song = appState.currentSong;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // 1. Static Header at the top (shows the dark grey background and logo/arrow)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 108,
                child: AnimatedBuilder(
                  animation: headerBgOpacity,
                  builder: (context, child) {
                    return Container(
                      color: const Color(0xFF1E1E1E).withValues(alpha: headerBgOpacity.value),
                      child: child,
                    );
                  },
                  child: _buildHeader(context),
                ),
              ),

              // 2. Sliding content section (the green part)
              Positioned(
                top: 108,
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                colors: [Color(0xFF2F5651), Color(0xFF1E1E1E)],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Quote container with fixed height (transparent, overlays onto gradient)
                                  Container(
                                    height: 160,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 30,
                                    ),
                                    child: Column(
                                      children: [
                                        // Quote text
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '"${song.quote}"',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontFamily: 'Griffiths',
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                                height: 1.3,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Friend tag
                                        Text(
                                          "${song.firstName}'s Favourite",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ALBUM ART
                                  Container(
                                    width: 270,
                                    height: 270,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.96),
                                          blurRadius: 50.0,
                                          offset: const Offset(0, 0),
                                          spreadRadius: -8,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        song.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey[700],
                                          child: Center(
                                            child: Text(
                                              song.title[0],
                                              style: const TextStyle(
                                                color: Colors.white30,
                                                fontSize: 80,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // SONG INFO
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      children: [
                                        // Song title
                                        Text(
                                          song.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 6),
                                        // Artist
                                        Text(
                                          song.artist,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // SEEKBAR
                                  _buildSeekbar(),

                                  // CONTROLS
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: _buildControls(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MusicPlayerRoute extends PageRouteBuilder {
  MusicPlayerRoute() : super(
    opaque: false,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) => const MusicPlayerScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Background and sheet slide animations are driven internally by routeAnimation inside MusicPlayerScreen!
      return child;
    },
    transitionDuration: const Duration(milliseconds: 550),
    reverseTransitionDuration: const Duration(milliseconds: 450),
  );
}

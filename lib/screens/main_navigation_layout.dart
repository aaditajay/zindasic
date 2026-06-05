import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../models/app_state.dart';
import '../widgets/liquid_glass.dart';
import 'home_screen.dart';
import 'people_screen.dart';
import 'about_screen.dart';
import 'music_player_screen.dart';
import 'login_screen.dart';

class MainNavigationLayout extends StatelessWidget {
  const MainNavigationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        // Define active screen
        Widget activeScreen;
        switch (appState.currentTab) {
          case 0:
            activeScreen = const HomeScreen(key: ValueKey(0));
            break;
          case 1:
            activeScreen = const PeopleScreen(key: ValueKey(1));
            break;
          case 2:
            activeScreen = const AboutScreen(key: ValueKey(2));
            break;
          default:
            activeScreen = const HomeScreen(key: ValueKey(0));
        }

        // Layout with bottom nav and mini player
        final Widget mainContent = Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E1E), Color(0xFF2F5651)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Screen content
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final isEntering = child.key == ValueKey(appState.currentTab);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: isEntering ? const Offset(0.0, 0.02) : const Offset(0.0, -0.02),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: activeScreen,
                  ),
                ),

                // Bottom Overlay: Mini Player & Navigation Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlassMiniPlayer(
                        songTitle: appState.currentSong.title,
                        artistName: '${appState.currentSong.artist} - ${appState.currentSong.favoriteBy}',
                        albumArt: AssetImage(appState.currentSong.imagePath),
                        isPlaying: appState.isPlaying,
                        isShuffle: appState.isShuffle,
                        onPlayPause: appState.togglePlay,
                        onShuffle: appState.toggleShuffle,
                        onQuote: () {
                          // Show the quote in a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF142421),
                              content: Text(
                                appState.currentSong.quote,
                                style: GoogleFonts.playfairDisplay(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.of(context).push(MusicPlayerRoute());
                        },
                      ),
                      GlassBottomNav(
                        currentIndex: appState.currentTab,
                        onTap: (i) => appState.setTab(i),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          child: !appState.isLoggedIn
              ? LoginScreen(
                  key: const ValueKey('login'),
                  onLoginComplete: () {},
                )
              : KeyedSubtree(
                  key: const ValueKey('content'),
                  child: mainContent,
                ),
        );
      },
    );
  }
}

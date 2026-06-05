import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/songs_data.dart';
import '../models/song.dart';
import '../models/app_state.dart';
import 'music_player_screen.dart';
import '../widgets/developer_contact_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ── Nav bar ────────────────────────────────────────────────────────────────
  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 23, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('public/logo.png', height: 65, fit: BoxFit.contain),
          const DeveloperContactButton(),
        ],
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void _navigateToPlayer(Song song) {
    appState.playSong(song);
    Navigator.of(context).push(MusicPlayerRoute());
  }

  // ── Top-pick card ──────────────────────────────────────────────────────────
  Widget _buildTopPickCard(Song song, int index) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(song),
      child: Container(
        width: 171,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 171,
              height: 171,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  song.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[700],
                    child: Center(
                      child: Text(song.title[0],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 48)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(song.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text("${song.firstName}'s Favourite",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w300)),
            const SizedBox(height: 1),
            Text(song.artist,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  // ── Song row ───────────────────────────────────────────────────────────────
  Widget _buildSongRow(Song song, int index) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(song),
      child: Container(
        padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  song.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[700],
                    child: Center(
                      child: Text(song.title[0],
                          style: const TextStyle(
                              color: Colors.white30, fontSize: 18)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text("${song.firstName}'s Favourite",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300)),
                  const SizedBox(height: 1),
                  Text(song.artist,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (appState.homeSortOption == HomeSortOption.custom) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.reorder_rounded,
                color: Colors.white24,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSortingPills() {
    final options = [
      (option: HomeSortOption.ascending, label: 'Ascending'),
      (option: HomeSortOption.descending, label: 'Descending'),
      (option: HomeSortOption.length, label: 'Length'),
      (option: HomeSortOption.custom, label: 'Custom'),
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.fromLTRB(17, 0, 17, 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final opt = options[index];
          final isSelected = appState.homeSortOption == opt.option;
          return GestureDetector(
            onTap: () => appState.setHomeSortOption(opt.option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: isSelected
                    ? const Color(0xFF0F7C72).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1AFBE5).withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0F7C72).withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: -1,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  opt.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return Stack(
            children: [
              // ── Scrollable content ────────────────────────────────────────
              SingleChildScrollView(
                // Extra bottom padding: nav bar (~80) + mini player (~66)
                padding: const EdgeInsets.only(bottom: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavBar(),
                    const SizedBox(height: 20),

                    // Greeting
                    Padding(
                      padding: const EdgeInsets.fromLTRB(58, 0, 22, 0),
                      child: Row(
                        children: [
                          Text(
                            'Hey ${appState.userName},',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onDoubleTap: appState.logout,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400]),
                              child: ClipOval(
                                  child: appState.userAvatar.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(appState.userAvatar),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.person,
                                                  size: 16,
                                                  color: Colors.white),
                                        )
                                      : const Icon(Icons.person,
                                          size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Hero text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Text.rich(
                        TextSpan(children: [
                          const TextSpan(
                            text:
                                'listen to the songs that define the people we ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Griffiths',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 3.2,
                              height: 1.2,
                            ),
                          ),
                          const TextSpan(
                            text: 'love.',
                            style: TextStyle(
                              color: Color(0xFF871919),
                              fontSize: 40,
                              fontFamily: 'Griffiths',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 3.2,
                              height: 1.2,
                            ),
                          ),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 38),

                    // Top picks label
                    const Padding(
                      padding: EdgeInsets.fromLTRB(17, 0, 0, 12),
                      child: Text('TOP PICKS FOR YOU',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w800)),
                    ),

                    // Top picks horizontal scroll
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                        itemCount: allSongs.take(4).length,
                        itemBuilder: (context, index) =>
                            _buildTopPickCard(allSongs[index], index),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Favourites label
                    const Padding(
                      padding: EdgeInsets.fromLTRB(17, 0, 0, 12),
                      child: Text("Favourites' Favourites",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w800)),
                    ),

                    _buildSortingPills(),

                    // Song list
                    if (appState.homeSortOption == HomeSortOption.custom)
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appState.sortedSongs.length,
                        itemBuilder: (context, index) {
                          final song = appState.sortedSongs[index];
                          return Container(
                            key: ValueKey(song.id),
                            child: _buildSongRow(song, index),
                          );
                        },
                        onReorderItem: (oldIndex, newIndex) {
                          appState.updateCustomSongOrder(oldIndex, newIndex);
                        },
                      )
                    else
                      Column(
                        children: appState.sortedSongs
                            .asMap()
                            .entries
                            .map((e) => _buildSongRow(e.value, e.key))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
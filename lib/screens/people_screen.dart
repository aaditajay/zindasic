import 'package:flutter/material.dart';
import '../models/song.dart';
import '../models/app_state.dart';
import 'music_player_screen.dart';
import '../widgets/developer_contact_button.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 23, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'public/logo.png',
            height: 65,
            fit: BoxFit.contain,
          ),
          const DeveloperContactButton(),
        ],
      ),
    );
  }

  void _navigateToPlayer(Song song) {
    appState.playSong(song);
    Navigator.of(context).push(MusicPlayerRoute());
  }

  Widget _buildPersonRow(Song song, int index) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(song),
      child: Container(
        padding: const EdgeInsets.fromLTRB(29, 15, 29, 15),
        color: Colors.transparent,
        child: Row(
          children: [
            // Profile photo
            Container(
              width: 59,
              height: 59,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[600],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  song.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[700],
                    child: Center(
                      child: Text(
                        song.firstName[0],
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),

            // Person info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    song.firstName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Song title
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Quote
                  Text(
                    '"${song.quote}"',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingPills() {
    final options = [
      (option: PeopleSortOption.ascending, label: 'Ascending'),
      (option: PeopleSortOption.descending, label: 'Descending'),
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.fromLTRB(29, 0, 29, 16),
      child: Row(
        children: options.map((opt) {
          final isSelected = appState.peopleSortOption == opt.option;
          return GestureDetector(
            onTap: () => appState.setPeopleSortOption(opt.option),
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
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                _buildNavBar(),

                const SizedBox(height: 20),

                // HERO TEXT
                const Padding(
                  padding: EdgeInsets.fromLTRB(23, 20, 23, 30),
                  child: Text(
                    'the ones who made these songs special.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Griffiths',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                _buildSortingPills(),

                // PEOPLE LIST
                ...appState.sortedPeopleSongs.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Song song = entry.value;
                  return _buildPersonRow(song, idx);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

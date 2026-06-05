import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/songs_data.dart';
import 'song.dart';

enum HomeSortOption { ascending, descending, length, custom }
enum PeopleSortOption { ascending, descending }

class AppState extends ChangeNotifier {
  // Singleton pattern for easy global access
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // User state
  String _userName = 'Aadit';
  String _userAvatar = '';
  bool _isLoggedIn = false;

  // Playback state
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song _currentSong = mockSongs[0]; // Default to Arz Kiya Hai
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  bool _isShuffle = false;
  bool _isRepeat = false;

  // Active navigation tab
  int _currentTab = 0; // 0: Home, 1: People, 2: About

  // Sorting state
  HomeSortOption _homeSortOption = HomeSortOption.custom;
  PeopleSortOption _peopleSortOption = PeopleSortOption.ascending;
  List<String> _customSongOrder = [];

  // Getters
  String get userName => _userName;
  String get userAvatar => _userAvatar;
  bool get isLoggedIn => _isLoggedIn;
  AudioPlayer get audioPlayer => _audioPlayer;
  Song get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  int get currentTab => _currentTab;

  HomeSortOption get homeSortOption => _homeSortOption;
  PeopleSortOption get peopleSortOption => _peopleSortOption;
  List<String> get customSongOrder => _customSongOrder;

  List<Song> get sortedSongs {
    final List<Song> list = List.from(allSongs);
    switch (_homeSortOption) {
      case HomeSortOption.ascending:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case HomeSortOption.descending:
        list.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case HomeSortOption.length:
        list.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case HomeSortOption.custom:
        list.sort((a, b) {
          final idxA = _customSongOrder.indexOf(a.id);
          final idxB = _customSongOrder.indexOf(b.id);
          if (idxA == -1 && idxB == -1) return 0;
          if (idxA == -1) return 1;
          if (idxB == -1) return -1;
          return idxA.compareTo(idxB);
        });
        break;
    }
    return list;
  }

  List<Song> get sortedPeopleSongs {
    final List<Song> list = List.from(allSongs);
    switch (_peopleSortOption) {
      case PeopleSortOption.ascending:
        list.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        break;
      case PeopleSortOption.descending:
        list.sort((a, b) => b.firstName.toLowerCase().compareTo(a.firstName.toLowerCase()));
        break;
    }
    return list;
  }

  // Asynchronous Initialization from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('has_onboarded') ?? false;
    if (_isLoggedIn) {
      _userName = prefs.getString('user_name') ?? 'Aadit';
      _userAvatar = prefs.getString('user_image_path') ?? '';
    }

    // Load sorting choices
    final homeSortStr = prefs.getString('home_sort_option');
    if (homeSortStr != null) {
      _homeSortOption = HomeSortOption.values.firstWhere(
        (e) => e.name == homeSortStr,
        orElse: () => HomeSortOption.custom,
      );
    }
    final peopleSortStr = prefs.getString('people_sort_option');
    if (peopleSortStr != null) {
      _peopleSortOption = PeopleSortOption.values.firstWhere(
        (e) => e.name == peopleSortStr,
        orElse: () => PeopleSortOption.ascending,
      );
    }
    final customOrderList = prefs.getStringList('custom_song_order');
    if (customOrderList != null) {
      _customSongOrder = List<String>.from(customOrderList);
    }
    _syncCustomSongOrder();

    // Set up AudioPlayer event listeners to synchronize with AppState
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((pos) {
      _currentPosition = pos;
      notifyListeners();
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        if (_isRepeat) {
          playSong(_currentSong);
        } else {
          playNext();
        }
      }
    });

    // Load initial song asset without auto-playing it
    try {
      await _audioPlayer.setAsset(_currentSong.audioPath);
    } catch (e) {
      debugPrint('Error loading initial song asset: $e');
    }

    notifyListeners();
  }

  void _syncCustomSongOrder() {
    final allIds = allSongs.map((s) => s.id).toList();
    _customSongOrder.removeWhere((id) => !allIds.contains(id));
    for (int i = 0; i < allIds.length; i++) {
      final id = allIds[i];
      if (!_customSongOrder.contains(id)) {
        _customSongOrder.insert(i, id);
      }
    }
  }

  Future<void> _saveCustomSongOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_song_order', _customSongOrder);
  }

  Future<void> setHomeSortOption(HomeSortOption option) async {
    _homeSortOption = option;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('home_sort_option', option.name);
    notifyListeners();
  }

  Future<void> setPeopleSortOption(PeopleSortOption option) async {
    _peopleSortOption = option;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('people_sort_option', option.name);
    notifyListeners();
  }

  Future<void> updateCustomSongOrder(int oldIndex, int newIndex) async {
    if (_homeSortOption != HomeSortOption.custom) return;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final String songId = _customSongOrder.removeAt(oldIndex);
    _customSongOrder.insert(newIndex, songId);
    await _saveCustomSongOrder();
    notifyListeners();
  }

  // Setters/Actions
  void login(String name, String imagePath) {
    _userName = name.trim().isEmpty ? 'User' : name;
    _userAvatar = imagePath;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _audioPlayer.stop();
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  Future<void> playSong(Song song) async {
    _currentSong = song;
    _isPlaying = true;
    _currentPosition = Duration.zero;
    notifyListeners();

    try {
      debugPrint('AppState: stopping player for new song');
      await _audioPlayer.stop();
      debugPrint('AppState: setting asset to ${song.audioPath}');
      await _audioPlayer.setAsset(song.audioPath);
      debugPrint('AppState: playing');
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  void togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    _audioPlayer.setLoopMode(_isRepeat ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  void playNext() {
    if (_isShuffle) {
      final nextIndex = (DateTime.now().millisecondsSinceEpoch) % mockSongs.length;
      playSong(mockSongs[nextIndex]);
      return;
    }

    final currentIndex = mockSongs.indexWhere((s) => s.id == _currentSong.id);
    if (currentIndex != -1) {
      int nextIndex = (currentIndex + 1) % mockSongs.length;
      playSong(mockSongs[nextIndex]);
    }
  }

  void playPrevious() {
    final currentIndex = mockSongs.indexWhere((s) => s.id == _currentSong.id);
    if (currentIndex != -1) {
      int prevIndex = currentIndex - 1;
      if (prevIndex < 0) prevIndex = mockSongs.length - 1;
      playSong(mockSongs[prevIndex]);
    }
  }
}

final appState = AppState();

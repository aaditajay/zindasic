class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String favoriteBy;
  final String personName;
  final String quote;
  final Duration duration;
  final String audioPath;
  final String imagePath;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.favoriteBy,
    required this.personName,
    required this.quote,
    required this.duration,
    required this.audioPath,
    required this.imagePath,
  });

  String get firstName => personName.split(RegExp(r'\s+')).first;
}

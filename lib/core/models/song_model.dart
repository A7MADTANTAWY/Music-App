// song_model.dart
class SongModel {
  final int id;
  final String songName;
  final String artistName;
  final String image;
  final String audioPath;
  bool isFavourite;

  SongModel({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.image,
    required this.audioPath,
    this.isFavourite = false,
  });
}

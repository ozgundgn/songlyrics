import '../../../models/song.dart';

abstract class SongProvider {
  Future<Iterable<CustomSong>> getSongsByLyrics({required String text});
}

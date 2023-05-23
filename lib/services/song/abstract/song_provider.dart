import '../../../models/song.dart';

abstract class SongProvider {
  Future<Iterable<Song>> getSongsByLyrics({required String text});
  Future<String> getLyrics({required String url});
}

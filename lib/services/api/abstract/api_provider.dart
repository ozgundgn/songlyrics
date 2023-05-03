import '../../../models/song.dart';

abstract class ApiProvider {
  Future<Iterable<Song>> getSongsByLyrics({required String text});
}

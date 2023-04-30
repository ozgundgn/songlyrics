import '../../../models/song.dart';

abstract class ApiProvider {
  void getSongsByLyrics({required String text});
}

import '../../../models/genius/geniussong.dart';

abstract class LyricsProvider {
  Future<String?> getLyrics(LyricsInfoModel? lyricsInfoModel);
}

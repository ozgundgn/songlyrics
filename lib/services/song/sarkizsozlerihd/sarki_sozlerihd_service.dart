import 'package:html/parser.dart';
import '../../../helpers/api_urls.dart';
import '../../../models/genius/geniussong.dart';
import '../abstract/lyrics_provider.dart';
import 'package:http/http.dart' as http;

class SarkiSozleriHdService implements LyricsProvider {
  @override
  Future<String?> getLyrics(LyricsInfoModel? lyricsInfoModel) async {
    final response = await http
        .get(Uri.parse('${SarkiSozleriHdApi.http}${lyricsInfoModel!.url}/'));
    var document = parse(response.body);
    var lyrics = document
        .getElementsByTagName("div")
        .where((el) => el.className.contains("lyric-text margint20 marginb20"))
        .map((item) => item.outerHtml)
        .toList();

    return lyrics.join();
  }
}

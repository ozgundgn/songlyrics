import 'dart:convert';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:songlyrics/models/genius/geniussong.dart';
import 'package:songlyrics/services/song/abstract/lyrics_provider.dart';
import 'package:songlyrics/services/song/abstract/song_provider.dart';
import 'package:http/http.dart' as http;
import '../../../helpers/api_urls.dart';
import '../../../models/song.dart';

class GeniusService implements SongProvider, LyricsProvider {
  Genius genius = Genius(accessToken: GeniusApi.token);
  @override
  Future<Iterable<CustomSong>> getSongsByLyrics({required String text}) async {
    final response =
        await http.get(Uri.parse('${GeniusApi.http}search?q=$text'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeniusApi.token}',
    });

    var body = jsonDecode(response.body);
    var hits = body["response"]["hits"];
    var songList =
        hits.map<GeniusSong>((json) => GeniusSong.fromJson(json)).toList();
    var g = songList
        .map<CustomSong>((el) => CustomSong(
            el.result.title, el.result.artistName, el.result.songUrl))
        .toList();
    return g;
  }

  @override
  Future<String?> getLyrics(LyricsInfoModel? lyricsInfoModel) async {
    if (lyricsInfoModel != null) {
      Song? song = (await genius.searchSong(
          artist: lyricsInfoModel.singer, title: lyricsInfoModel.song));
      List<String>? lyrics = song?.lyrics!.split("Lyrics");
      if (lyrics != null) {
        return lyrics[1];
      }
    }
    return "";
    // final response = await http.get(Uri.parse(url!));
    // await Sentry.captureMessage(
    //     "Url will be parsed in getlyrics metohod in genius service",
    //     level: SentryLevel.info);
    // var document = await compute(parse, response.body);
    // await Sentry.captureMessage("Parsed url response from genius service",
    //     level: SentryLevel.info);
    // var lyrics = document
    //     .getElementsByTagName("div")
    //     .where((el) => el.attributes["data-lyrics-container"] == "true")
    //     .map((item) => item.outerHtml)
    //     .toList();

    // return lyrics.join();
  }
}

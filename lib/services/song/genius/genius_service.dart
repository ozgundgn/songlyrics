import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:songlyrics/models/genius/geniussong.dart';
import 'package:songlyrics/services/song/abstract/lyrics_provider.dart';
import 'package:songlyrics/services/song/abstract/song_provider.dart';
import 'package:http/http.dart' as http;
import '../../../helpers/api_urls.dart';
import '../../../models/song.dart';

class GeniusService implements SongProvider, LyricsProvider {
  @override
  Future<Iterable<Song>> getSongsByLyrics({required String text}) async {
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
        .map<Song>((el) =>
            Song(el.result.title, el.result.artistName, el.result.songUrl))
        .toList();
    return g;
  }

  @override
  Future<String> getLyrics(String? url) async {
    final response = await http.get(Uri.parse(url!));
    await Sentry.captureMessage(
        "Url will be parsed in getlyrics metohod in genius service",
        level: SentryLevel.info);
    var document = await compute(parse, response.body);
    await Sentry.captureMessage("Parsed url response from genius service",
        level: SentryLevel.info);
    var lyrics = document
        .getElementsByTagName("div")
        .where((el) => el.attributes["data-lyrics-container"] == "true")
        .map((item) => item.outerHtml)
        .toList();

    return lyrics.join();
  }
}

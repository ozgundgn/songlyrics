import 'dart:convert';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:songlyrics/models/spotify/spotifysong.dart';
import 'package:songlyrics/models/spotify/token.dart';
import '../../../helpers/api_urls.dart';
import '../../../models/song.dart';
import '../abstract/song_provider.dart';

class SpotifyService implements SongProvider {
  SpotifyToken? _token;

  Future<SpotifyToken?> getToken() async {
    final response = await http.post(Uri.parse(SpotifyApi.httpToken), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': '*/*'
    }, body: {
      'grant_type': 'client_credentials',
      'client_id': '794b29b21e5f4df7beb043b1382c31bf',
      'client_secret': '8a11294676e24967a00b26e27197d280',
    });

    var body = jsonDecode(response.body);
    var token = body["access_token"];
    _token = SpotifyToken(
        token, "tokenType", DateTime.now().add(const Duration(minutes: 3600)));
    return _token;
  }

  @override
  Future<Iterable<CustomSong>> getSongsByLyrics({required String text}) async {
    if (_token != null) {
      if (DateTime.now().isAfter(_token!.expireDate)) {
        _token = await getToken();
      }
    } else {
      _token = await getToken();
    }

    final response = await http.get(
        Uri.parse('${SpotifyApi.httpRequest}search?type=track&q=$text'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': '*/*',
          'Authorization': 'Bearer ${_token!.accessToken}',
        });

    var body = jsonDecode(response.body);
    var hits = body["tracks"]["items"];
    var songs =
        hits.map<SpotifySong>((json) => SpotifySong.fromJson(json)).toList();

    var g = songs
        .map<CustomSong>((el) => CustomSong(el.songName, el.artistName, el.url))
        .toList();
    return g;
  }
}

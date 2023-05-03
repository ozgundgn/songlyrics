import 'dart:convert';
import 'package:songlyrics/models/song.dart';
import 'package:songlyrics/services/api/abstract/api_provider.dart';
import 'package:http/http.dart' as http;
import '../../../helpers/api_urls.dart';

class GeniusService implements ApiProvider {
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
    var songList = hits.map<Song>((json) => Song.fromJson(json)).toList();
    return songList;
  }
}

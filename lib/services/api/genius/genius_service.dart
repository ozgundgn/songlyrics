import 'package:songlyrics/models/song.dart';
import 'package:songlyrics/services/api/abstract/api_provider.dart';
import 'package:http/http.dart' as http;
import '../../../helpers/api_urls.dart';

class GeniusService implements ApiProvider {
  @override
  /* Future<Iterable<Song>> */ void getSongsByLyrics(
      {required String text}) async {
    final response = await http
        .get(Uri.parse(GeniusApi.http + '/search?q=' + text), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GeniusApi.token}',
    });
    if (response.statusCode == 200) {}
  }
}

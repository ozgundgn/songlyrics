import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';
import 'package:songlyrics/services/song/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';

class SongLyricsView extends StatefulWidget {
  const SongLyricsView({super.key});

  @override
  State<SongLyricsView> createState() => _SongLyricsViewState();
}

class _SongLyricsViewState extends State<SongLyricsView> {
  late GeniusService _apiProvider;
  @override
  void initState() {
    _apiProvider = GeniusService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Deneme? _deneme;
  Future<String> getLyrics(BuildContext context) async {
    var url = context.getArgument<String>();
    var lyrics = await _apiProvider.getLyrics(url: url!);

    _deneme = context.getArgument<Deneme>();
    return lyrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.song_lyrics(
          _deneme?.singer ?? "",
          _deneme?.song ?? "",
        )),
      ),
      body: FutureBuilder<String>(
        future: getLyrics(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Center(
                  child: SingleChildScrollView(
                    child: Html(
                      data: snapshot.data?.replaceAll("<a", "<p"),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }
}

class Deneme {
  final String url;
  final String singer;
  final String song;

  Deneme(this.url, this.singer, this.song);
}

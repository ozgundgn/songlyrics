import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:songlyrics/services/song/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';

import '../../models/song.dart';

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

  Future<LyricsInfoModel?> getLyrics(BuildContext context) async {
    var lyricsInfoModel = context.getArgument<LyricsInfoModel>();
    if (lyricsInfoModel != null) {
      var lyrics = await _apiProvider.getLyrics(url: lyricsInfoModel.url);
      lyricsInfoModel.lyrics = lyrics;
    }
    return lyricsInfoModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<LyricsInfoModel?>(
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
                      data:
                          "<b>${snapshot.data!.singer} - ${snapshot.data!.song}</b><br><br>${snapshot.data!.lyrics?.replaceAll("<a", "<p")}",
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

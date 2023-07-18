import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';
import 'package:songlyrics/services/song/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';

import '../../models/genius/geniussong.dart';
import '../../services/song/sarkizsozlerihd/sarki_sozlerihd_service.dart';

class SongLyricsView extends StatefulWidget {
  const SongLyricsView({super.key});

  @override
  State<SongLyricsView> createState() => _SongLyricsViewState();
}

class _SongLyricsViewState extends State<SongLyricsView> {
  late SarkiSozleriHdService _apiProvider;
  @override
  void initState() {
    _apiProvider = SarkiSozleriHdService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<LyricsInfoModel?> getLyrics(BuildContext context) async {
    var lyricsInfoModel = context.getArgument<LyricsInfoModel>();
    if (lyricsInfoModel != null) {
      // var songList = await _apiProvider.getSongsByLyrics(
      //     text: "${lyricsInfoModel.singer} ${lyricsInfoModel.song}");
      // if (songList.isNotEmpty) {
      // var thatSong = songList.where((element) =>
      //     element.artistName == lyricsInfoModel.singer &&
      //     element.songName == lyricsInfoModel.song);
      // if (thatSong.isNotEmpty) {
      //   var lyrics =
      //     await _apiProvider.getLyrics("$singerName $songName".toParamCase());
      // lyricsInfoModel.lyrics = lyrics;
      // }
      String songName = lyricsInfoModel.song
          .toLowerCase()
          .replaceAll('ç', 'c')
          .replaceAll('ğ', 'g')
          .replaceAll('ş', 's')
          .replaceAll('ü', 'u')
          .replaceAll('ö', 'o')
          .replaceAll('ı', 'i');

      String singerName = lyricsInfoModel.singer
          .toLowerCase()
          .replaceAll('ç', 'c')
          .replaceAll('ğ', 'g')
          .replaceAll('ş', 's')
          .replaceAll('ü', 'u')
          .replaceAll('ö', 'o')
          .replaceAll('ı', 'i');
      var lyrics =
          await _apiProvider.getLyrics("$singerName $songName".toParamCase());
      lyricsInfoModel.lyrics = lyrics;
      // }
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
                          "<b>${snapshot.data!.singer} - ${snapshot.data!.song}</b><br><br>${snapshot.data!.lyrics == null ? context.loc.couldnt_find_lyrics : snapshot.data!.lyrics?.replaceAll("<a", "<p")}",
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

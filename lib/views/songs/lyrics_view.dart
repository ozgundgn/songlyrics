import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';
import 'package:songlyrics/services/song/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';
import '../../models/genius/geniussong.dart';
import '../../services/ads/google_ads.dart';
import '../../services/song/sarkizsozlerihd/sarki_sozlerihd_service.dart';

class SongLyricsView extends StatefulWidget {
  const SongLyricsView({super.key});

  @override
  State<SongLyricsView> createState() => _SongLyricsViewState();
}

class _SongLyricsViewState extends State<SongLyricsView> {
  late GeniusService _apiGeniusService;
  late SarkiSozleriHdService _apiSarkiSozleriService;
  GoogleAds googleAds = GoogleAds();
  @override
  void initState() {
    _apiSarkiSozleriService = SarkiSozleriHdService();
    _apiGeniusService = GeniusService();
    googleAds.loadAdInterstitial(showAfterLoad: true);
    googleAds.loadAdBanner(
      adLoaded: () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<LyricsInfoModel?> getLyrics(BuildContext context) async {
    googleAds.showInterstitialAd();

    var lyricsInfoModel = context.getArgument<LyricsInfoModel>();
    if (lyricsInfoModel != null) {
      var songList = await _apiGeniusService.getSongsByLyrics(
          text: "${lyricsInfoModel.singer} ${lyricsInfoModel.song}");
      if (songList.isNotEmpty) {
        var searchSong = replaceTurkishChar(lyricsInfoModel.song);
        var searchSinger = replaceTurkishChar(lyricsInfoModel.singer);
        var thatSong = songList.where((element) =>
            replaceTurkishChar(element.artistName).contains(searchSinger) &&
            replaceTurkishChar(element.songName).contains(searchSong));
        if (thatSong.isNotEmpty) {
          var lyrics = await _apiGeniusService.getLyrics(thatSong.first.url);
          lyricsInfoModel.lyrics = lyrics;
        } else {
          var lyrics = await sarkiSozuHdPart(lyricsInfoModel);
          lyricsInfoModel.lyrics = lyrics;
        }
      } else {
        var lyrics = await sarkiSozuHdPart(lyricsInfoModel);
        lyricsInfoModel.lyrics = lyrics;
      }
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
                          "<b>${snapshot.data!.singer} - ${snapshot.data!.song}</b><br><br>${snapshot.data!.lyrics!.isEmpty ? context.loc.couldnt_find_lyrics : snapshot.data!.lyrics?.replaceAll("<a", "<p")}",
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

  Future<String> sarkiSozuHdPart(LyricsInfoModel lyricsInfoModel) async {
    String songName = replaceTurkishChar(lyricsInfoModel.song);
    String singerName = replaceTurkishChar(lyricsInfoModel.singer);
    String lyrics = await _apiSarkiSozleriService
        .getLyrics("$singerName $songName".toParamCase());
    return lyrics;
  }

  String replaceTurkishChar(String word) {
    return word
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ı', 'i');
  }
}

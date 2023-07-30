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
  late SarkiSozleriHdService _apiSarkiSozleriService;
  late GeniusService _geniusService;
  GoogleAds googleAds = GoogleAds();

  @override
  void initState() {
    _geniusService = GeniusService();
    _apiSarkiSozleriService = SarkiSozleriHdService();
    googleAds.loadAdInterstitial(showAfterLoad: false);
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
    var lyricsInfoModel = context.getArgument<LyricsInfoModel>();

    if (lyricsInfoModel != null) {
      String? lyrics = await _geniusService.getLyrics(lyricsInfoModel);
      if (lyrics != null && lyrics.isNotEmpty) {
        lyricsInfoModel.lyrics = lyrics;
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
                if (snapshot.data != null) {
                  if (snapshot.data!.lyrics!.contains("<")) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Html(
                          data:
                              "<b>${snapshot.data!.singer} - ${snapshot.data!.song}</b><br><br>${snapshot.data!.lyrics!.isEmpty ? context.loc.couldnt_find_lyrics : snapshot.data!.lyrics?.replaceAll("<a", "<p")}",
                        ),
                      ),
                    );
                  } else {
                    return ListView(children: [
                      Center(
                        child: Text(
                          "${snapshot.data!.singer} - ${snapshot.data!.song}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          child: Text(snapshot.data!.lyrics!),
                        ),
                      ),
                    ]);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }

  Future<String> sarkiSozuHdPart(LyricsInfoModel lyricsInfoModel) async {
    String? songName = replaceTurkishChar(lyricsInfoModel.song!);
    String? singerName = replaceTurkishChar(lyricsInfoModel.singer!);
    String url = "$singerName $songName".toParamCase();
    String? lyrics = await _apiSarkiSozleriService
        .getLyrics(LyricsInfoModel(null, null, null, url));
    return lyrics!;
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

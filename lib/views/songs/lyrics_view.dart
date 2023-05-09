import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:songlyrics/helpers/api_urls.dart';
import 'package:songlyrics/services/api/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';

import '../../services/api/abstract/api_provider.dart';

class SongLyricsView extends StatefulWidget {
  const SongLyricsView({super.key});

  @override
  State<SongLyricsView> createState() => _SongLyricsViewState();
}

class _SongLyricsViewState extends State<SongLyricsView> {
  late final ApiProvider _apiProvider;
  String? url = "";

  @override
  void initState() {
    _apiProvider = GeniusService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getLyrics(BuildContext context) async {
    var text = context.getArgument<String>();
    url = text;
    var lyrics = await _apiProvider.getLyrics(url: url!);
    return lyrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şarkı Sözleri'),
      ),
      body: FutureBuilder<String>(
        future: getLyrics(context),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                String lyrics = snapshot.data as String;
                return Text(lyrics);
              } else {
                return const Text('Empty!');
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:songlyrics/services/api/abstract/api_provider.dart';
import 'package:songlyrics/services/api/genius/genius_service.dart';
import 'package:songlyrics/utilities/get_arguments.dart';
import 'package:songlyrics/views/songs/songs_list_view.dart';
import '../../models/song.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map(((t) => t.length));
}

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  late final ApiProvider _apiProvider;
  String? _searchingText = "";
  @override
  void initState() {
    _apiProvider = GeniusService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Iterable<Song>> getText(BuildContext context) async {
    var text = context.getArgument<String>();
    _searchingText = text;
    var list = await _apiProvider.getSongsByLyrics(text: text!);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getText(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final soundCount = snapshot.data!.length;
              String text = '$soundCount şarkı bulundu!';
              return Text(text);
            } else {
              return const Text('Şarkı bulunamadı!');
            }
          },
        ),
      ),
      body: FutureBuilder<Iterable<Song>>(
        future: _apiProvider.getSongsByLyrics(text: _searchingText!),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final allSongs = snapshot.data as Iterable<Song>;
                return SongsListView(songs: allSongs);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

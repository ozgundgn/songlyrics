import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songlyrics/constants/routes.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';
import 'package:songlyrics/views/songs/songs_list_view.dart';
import '../../models/song.dart';
import '../../services/song/bloc/song_bloc.dart';
import '../../services/song/bloc/song_event.dart';
import '../../services/song/bloc/song_state.dart';
import 'lyrics_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map(((t) => t.length));
}

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  Iterable<Song>? _songList;

  // Future<Iterable<Song>> getText(BuildContext context) async {
  //   var text = context.getArgument<String>();
  //   _searchingText = text;
  //   var list = await _apiProvider.getSongsByLyrics(text: text!);
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongStateFound) {
          _songList = state.list;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(context.loc.songs_title(_songList?.length ?? 0)),
              leading: BackButton(
                onPressed: () =>
                    context.read<SongBloc>().add(const SongEventInitialize()),
              ),
            ),
            body: SongsListView(
              songs: _songList!,
              onTap: (song) async {
                Navigator.of(context).pushNamed(songLyricsView,
                    arguments: Deneme(
                      song.result.songUrl,
                      song.result.artistName,
                      song.result.title,
                    ));
                // context.read<SongBloc>().add(
                //       SongEventLyricsSearching(song.result.songUrl),
                //     );
              },
            ));
      },
    );
  }
}

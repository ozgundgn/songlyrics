import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/song.dart';
import '../../services/song/bloc/song_bloc.dart';
import '../../services/song/bloc/song_state.dart';

typedef SongsCallback = void Function(Song song);

class SongsListView extends StatelessWidget {
  final Iterable<Song> songs;
  final SongsCallback onTap;

  const SongsListView({super.key, required this.songs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs.elementAt(index);
            return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 200,
                  child: ListTile(
                    onTap: () {
                      onTap(song);
                    },
                    mouseCursor: SystemMouseCursors.click,
                    title: Text(
                      song.songName,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.artistName,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        Share.share(song.url!);
                      },
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}

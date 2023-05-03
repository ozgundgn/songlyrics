import 'package:flutter/material.dart';
import '../../models/song.dart';
import 'package:share_plus/share_plus.dart';

typedef SongsCallback = void Function(Song song);

class SongsListView extends StatelessWidget {
  final Iterable<Song> songs;
  // final SongsCallback onTap;

  const SongsListView({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs.elementAt(index);
        return ListTile(
          // onTap: () {
          //   onTap(song);
          // },
          title: Text(
            song.result.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Text(
            song.result.artistName,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              Share.share(song.result.title);
            },
          ),
        );
      },
    );
  }
}

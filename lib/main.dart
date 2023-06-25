import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songlyrics/helpers/loading/loading_screen.dart';
import 'package:songlyrics/services/song/genius/genius_service.dart';
import 'package:songlyrics/services/song/bloc/song_bloc.dart';
import 'package:songlyrics/services/song/bloc/song_event.dart';
import 'package:songlyrics/services/song/bloc/song_state.dart';
import 'package:songlyrics/views/songs/lyrics_view.dart';
import 'package:songlyrics/views/songs/search.dart';
import 'package:songlyrics/views/songs/songs_view.dart';

import 'constants/routes.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => SongBloc(GeniusService()),
      child: MaterialApp(
        //dil eklenecek
        title: 'Sofly',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const HomePage(title: 'Sofly'),
        routes: {
          searchView: ((context) => const SearchView()),
          songsView: (context) => const SongsView(),
          songLyricsView: (context) => const SongLyricsView()
        },
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SongBloc>().add(const SongEventInitialize());
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText!,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is SongStateFound) {
          return const SongsView();
        } else {
          return const SearchView();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/dialogs/cannot_search_empty_text.dart';
import 'bloc/song_bloc.dart';
import 'bloc/song_event.dart';
import 'bloc/song_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("ss"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Şarkı bulalım!"),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Şarkının bir kısmı...',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final searchText = _textController.text;
                    if (searchText.trim().isEmpty) {
                      await showCannotSearchTextDialog(context);
                    } else {
                      // Navigator.of(context).pushNamed(
                      //   songsView,
                      //   arguments: searchText,
                      // );
                      context.read<SongBloc>().add(
                            SongEventSongSearching(searchText),
                          );
                    }
                  },
                  child: const Text('Bul'),
                ),
              ],
            ),
          ),
          //   floatingActionButton: FloatingActionButton(
          //     onPressed: _incrementCounter,
          //     tooltip: 'Increment',
          //     child: const Icon(Icons.add),
          //   ), // This trailing comma makes auto-formatting nicer for build methods.
          //
        );
      },
    );
  }
}

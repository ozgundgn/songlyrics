import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';
import '../../utilities/dialogs/cannot_search_empty_text.dart';
import '../../services/song/bloc/song_bloc.dart';
import '../../services/song/bloc/song_event.dart';
import '../../services/song/bloc/song_state.dart';

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
            title: Text(context.loc.my_title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.loc.song_find,
                  style: GoogleFonts.montserrat(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: context.loc.input_search_text,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 226, 153, 241),
                                Color.fromARGB(255, 234, 102, 231),
                                Color.fromARGB(255, 210, 44, 232),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(5.0),
                        ),
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
                                  SongEventSongSearching(
                                    searchText,
                                    context.loc.waiting_text,
                                  ),
                                );
                          }
                        },
                        child: Text(
                          context.loc.find_button_text,
                          style: GoogleFonts.montserrat(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
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

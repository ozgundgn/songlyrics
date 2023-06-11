import 'package:bloc/bloc.dart';
import 'package:songlyrics/views/songs/bloc/song_event.dart';
import 'package:songlyrics/views/songs/bloc/song_state.dart';
import '../../../models/song.dart';
import '../../../services/song/abstract/song_provider.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc(SongProvider provider)
      : super(const SongStateInitialize(isLoading: false)) {
    on<SongEventInitialize>((event, emit) =>
        {emit(const SongStateSearching(isLoading: false, exception: null))});

    on<SongEventSongSearching>((event, emit) async {
      emit(const SongStateSearching(exception: null, isLoading: true));
      final text = event.searchText;
      if (text == null) {
        emit(const SongStateSearching(exception: null, isLoading: false));
      }
      Exception? exception;
      Iterable<Song>? list;
      try {
        list = await provider.getSongsByLyrics(text: text!);
        exception = null;
      } on Exception catch (e) {
        exception = e;
      }
      emit(SongStateFound(
        exception: exception,
        isLoading: false,
        list: list,
      ));
    });

    on<SongEventLyricsSearching>(
      (event, emit) async {
        emit(const SongStateLyricsSearching(exception: null, isLoading: true));

        final songUrl = event.url;

        if (songUrl == null) {
          emit(const SongStateInitialize(isLoading: false));
          return;
        }
        Exception? exception;
        String lyrics = "";
        try {
          lyrics = await provider.getLyrics(url: songUrl);
          exception = null;
        } on Exception catch (e) {
          exception = e;
        }
        emit(
          SongStateLyricsFound(
              exception: exception, isLoading: false, lyrics: lyrics),
        );
      },
    );
  }
}

import 'package:flutter/foundation.dart';

@immutable
abstract class SongEvent {
  const SongEvent();
}

class SongEventInitialize extends SongEvent {
  const SongEventInitialize();
}

class SongEventSongSearching extends SongEvent {
  final String? searchText;
  final String? loadingText;
  const SongEventSongSearching(this.searchText, this.loadingText);
}

class SongEventLyricsSearching extends SongEvent {
  final String? url;
  final String? loadingText;
  const SongEventLyricsSearching(this.url, this.loadingText);
}

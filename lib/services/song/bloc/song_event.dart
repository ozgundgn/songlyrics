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
  const SongEventSongSearching(this.searchText);
}

class SongEventLyricsSearching extends SongEvent {
  final String? url;
  const SongEventLyricsSearching(this.url);
}

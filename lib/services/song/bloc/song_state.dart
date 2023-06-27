import 'package:flutter/foundation.dart' show immutable;

import '../../../models/song.dart';

@immutable
abstract class SongState {
  final bool isLoading;
  final String? loadingText;
  const SongState({
    required this.isLoading,
    this.loadingText = "Please wait",
  });
}

class SongStateInitialize extends SongState {
  const SongStateInitialize({required super.isLoading});
}

class SongStateSearching extends SongState {
  final Exception? exception;
  const SongStateSearching({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });
}

class SongStateFound extends SongState {
  final Exception? exception;
  final Iterable<Song>? list;
  const SongStateFound(
      {required this.list, required this.exception, required super.isLoading});
}

class SongStateLyricsSearching extends SongState {
  final Exception? exception;
  const SongStateLyricsSearching({
    required this.exception,
    required super.isLoading,
  });
}

class SongStateLyricsFound extends SongState {
  final Exception? exception;
  final String? lyrics;
  const SongStateLyricsFound(
      {required this.lyrics,
      required this.exception,
      required super.isLoading});
}

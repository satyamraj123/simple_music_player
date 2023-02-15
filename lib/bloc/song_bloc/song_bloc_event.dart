part of 'song_bloc_bloc.dart';

@immutable
abstract class SongBlocEvent {
  const SongBlocEvent();
}

class FetchSongEvent extends SongBlocEvent {
  @override
  String toString() => 'FetchSongEvent';
}

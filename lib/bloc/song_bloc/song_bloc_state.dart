part of 'song_bloc_bloc.dart';

@immutable
abstract class SongBlocState {}

class SongBlocInitial extends SongBlocState {}

class FetchingSongState extends SongBlocState {
  @override
  String toString() => 'FetchingSongState';
}

class FetchedSongState extends SongBlocState {
  final List<Song> songs;
  FetchedSongState(this.songs);

  @override
  String toString() => 'FetchedSongState';
}

class FetchedSongErrorState extends SongBlocState {

  @override
  String toString() => 'FetchedSongErrorState';
}

part of 'player_bloc_bloc.dart';

@immutable
abstract class PlayerBlocState {}

class PlayerBlocInitial extends PlayerBlocState {}

class PlayingState extends PlayerBlocState {
  final Song currentSong;
  final Duration currentPosition;
  final Duration totalDuration;
  PlayingState(this.currentSong, this.currentPosition, this.totalDuration);
  @override
  String toString() => 'PlayingState';
}

class ChangedSongState extends PlayerBlocState {
  final Song currentSong;
  final Song? previousSong;
  final Song? nextSong;
  final Duration totalDuration;
  ChangedSongState(
      this.currentSong, this.previousSong, this.nextSong, this.totalDuration);
  @override
  String toString() => 'ChangedSongState';
}

class PausedState extends PlayerBlocState {
  PausedState();
  @override
  String toString() => 'PausedState';
}

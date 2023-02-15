part of 'player_bloc_bloc.dart';

@immutable
abstract class PlayerBlocState {}

class PlayerBlocInitial extends PlayerBlocState {}

class PlayingState extends PlayerBlocState {
  final Song currentSong;
  final Duration currentPosition;

  PlayingState(this.currentSong,this.currentPosition);
  @override
  String toString() => 'PlayingState';
}

class PausedState extends PlayerBlocState {
  final Song currentSong;
  PausedState(this.currentSong);
  @override
  String toString() => 'PausedState';
}
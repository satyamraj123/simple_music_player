part of 'player_bloc_bloc.dart';

@immutable
abstract class PlayerBlocEvent {
  const PlayerBlocEvent();
}

class ChangeSongEvent extends PlayerBlocEvent {
  final Song song;
  const ChangeSongEvent(this.song);
  @override
  String toString() => 'ChangeSongEvent';
}

class PauseSongEvent extends PlayerBlocEvent {
  final Song song;
  const PauseSongEvent(this.song);
  @override
  String toString() => 'PauseSongEvent';
}

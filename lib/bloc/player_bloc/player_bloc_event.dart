part of 'player_bloc_bloc.dart';

@immutable
abstract class PlayerBlocEvent {
  const PlayerBlocEvent();
}

class ChangeSongEvent extends PlayerBlocEvent {
  final Song song;
  final Duration playFromDuration;
  const ChangeSongEvent(this.song, this.playFromDuration);
  @override
  String toString() => 'ChangeSongEvent';
}

class ChangeNextSongEvent extends PlayerBlocEvent {
  const ChangeNextSongEvent();
  @override
  String toString() => 'ChangeNextSongEvent';
}

class ChangePreviousSongEvent extends PlayerBlocEvent {
  const ChangePreviousSongEvent();
  @override
  String toString() => 'ChangePreviousSongEvent';
}

class PauseSongEvent extends PlayerBlocEvent {
  const PauseSongEvent();
  @override
  String toString() => 'PauseSongEvent';
}

class UnPauseSongEvent extends PlayerBlocEvent {
  const UnPauseSongEvent();
  @override
  String toString() => 'UnPauseSongEvent';
}

class PlayFromDurationSongEvent extends PlayerBlocEvent {
  final Duration playFromDuration;
  const PlayFromDurationSongEvent(this.playFromDuration);
  @override
  String toString() => 'PlayFromDurationSongEvent';
}

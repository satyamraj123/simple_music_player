import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/repositories/song_repository.dart';

part 'player_bloc_event.dart';
part 'player_bloc_state.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class PlayerBloc extends Bloc<PlayerBlocEvent, PlayerBlocState> {
  PlayerBloc() : super(PlayerBlocInitial()) {
    on<ChangeSongEvent>(mapChangeSongEventToState, transformer: restartable());
    on<ChangeNextSongEvent>(mapChangeNextSongEventToState,
        transformer: restartable());
    on<ChangePreviousSongEvent>(mapChangePreviousSongEventToState,
        transformer: restartable());
    on<PauseSongEvent>(mapPauseSongEventToState, transformer: restartable());
    on<UnPauseSongEvent>(mapUnPauseSongEventToState,
        transformer: restartable());
    on<PlayFromDurationSongEvent>(mapPlayFromDurationSongEventToState,
        transformer: restartable());
  }
  final songRepository = SongRepository();
  List<Song> songStack = [];
  int currentSongIndex = -1;
  void mapChangeSongEventToState(
      ChangeSongEvent event, Emitter<PlayerBlocState> emit) async {
    songStack.add(event.song);
    currentSongIndex = currentSongIndex + 1;
    await audioPlayer.stop();
    await audioPlayer.setUrl(event.song.path);
    audioPlayer.seek(event.playFromDuration);
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(
        event.song,
        currentSongIndex == 0 ? null : songStack[currentSongIndex - 1],
        currentSongIndex >= songStack.length - 1
            ? null
            : songStack[currentSongIndex + 1],
        totalDuration!));
    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(event.song, data, totalDuration);
    }));
  }

  void mapChangeNextSongEventToState(
      ChangeNextSongEvent event, Emitter<PlayerBlocState> emit) async {
    currentSongIndex = currentSongIndex + 1;
    await audioPlayer.stop();
    await audioPlayer.setUrl(songStack[currentSongIndex].path);
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(
        songStack[currentSongIndex],
        currentSongIndex == 0 ? null : songStack[currentSongIndex - 1],
        currentSongIndex >= songStack.length - 1
            ? null
            : songStack[currentSongIndex + 1],
        totalDuration!));
    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(songStack[currentSongIndex], data, totalDuration);
    }));
  }

  void mapChangePreviousSongEventToState(
      ChangePreviousSongEvent event, Emitter<PlayerBlocState> emit) async {
    currentSongIndex = currentSongIndex - 1;
    await audioPlayer.stop();
    await audioPlayer.setUrl(songStack[currentSongIndex].path);
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(
        songStack[currentSongIndex],
        currentSongIndex == 0 ? null : songStack[currentSongIndex - 1],
        currentSongIndex >= songStack.length - 1
            ? null
            : songStack[currentSongIndex + 1],
        totalDuration!));
    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(songStack[currentSongIndex], data, totalDuration);
    }));
  }

  void mapPauseSongEventToState(
      PauseSongEvent event, Emitter<PlayerBlocState> emit) async {
    await audioPlayer.pause();
    emit(PausedState());
  }

  void mapUnPauseSongEventToState(
      UnPauseSongEvent event, Emitter<PlayerBlocState> emit) async {
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(
        songStack[currentSongIndex],
        currentSongIndex == 0 ? null : songStack[currentSongIndex - 1],
        currentSongIndex >= songStack.length - 1
            ? null
            : songStack[currentSongIndex + 1],
        totalDuration!));
    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(songStack[currentSongIndex], data, totalDuration);
    }));
  }

  void mapPlayFromDurationSongEventToState(
      PlayFromDurationSongEvent event, Emitter<PlayerBlocState> emit) async {
    audioPlayer.seek(event.playFromDuration);
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(
        songStack[currentSongIndex],
        currentSongIndex == 0 ? null : songStack[currentSongIndex - 1],
        currentSongIndex >= songStack.length - 1
            ? null
            : songStack[currentSongIndex + 1],
        totalDuration!));
    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(songStack[currentSongIndex], data, totalDuration);
    }));
  }
}

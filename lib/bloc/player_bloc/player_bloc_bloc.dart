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
    on<PauseSongEvent>(mapPauseSongEventToState);
  }
  final songRepository = SongRepository();

  void mapChangeSongEventToState(
      ChangeSongEvent event, Emitter<PlayerBlocState> emit) async {
    await audioPlayer.stop();

    await audioPlayer.setUrl(event.song.path);
    audioPlayer.play();
    Duration? totalDuration = audioPlayer.duration;
    emit(ChangedSongState(event.song, totalDuration!));

    await emit.forEach(audioPlayer.createPositionStream(), onData: ((data) {
      return PlayingState(event.song, data, totalDuration);
    }));
    // audioPlayer.positionStream.forEach(((element) => emit(PlayingState(event.song,element))));
  }

  void mapPauseSongEventToState(
      PauseSongEvent event, Emitter<PlayerBlocState> emit) async {
    await audioPlayer.stop();
    emit(PausedState(event.song));
  }
}

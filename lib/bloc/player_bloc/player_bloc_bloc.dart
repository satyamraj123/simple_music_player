import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/repositories/song_repository.dart';

part 'player_bloc_event.dart';
part 'player_bloc_state.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class PlayerBloc extends Bloc<PlayerBlocEvent, PlayerBlocState> {
  PlayerBloc() : super(PlayerBlocInitial()) {
    on<ChangeSongEvent>(mapChangeSongEventToState);
    on<PauseSongEvent>(mapPauseSongEventToState);
  }
  final songRepository = SongRepository();

  void mapChangeSongEventToState(
      ChangeSongEvent event, Emitter<PlayerBlocState> emit) async {
    await audioPlayer.stop();
    await audioPlayer.setUrl(event.song.path);
    audioPlayer.play();
    emit(PlayingState(event.song, const Duration(seconds: 0)));
    await emit.forEach(audioPlayer.positionStream, onData: ((data) {
      return PlayingState(event.song, data);
    }));
    // audioPlayer.positionStream.forEach(((element) => emit(PlayingState(event.song,element))));
  }

  void mapPauseSongEventToState(
      PauseSongEvent event, Emitter<PlayerBlocState> emit) async {
    await audioPlayer.stop();
    emit(PausedState(event.song));
  }
}

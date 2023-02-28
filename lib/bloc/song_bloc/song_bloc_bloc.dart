import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/providers/song_provider.dart';
import 'package:simple_music_player/repositories/song_repository.dart';

part 'song_bloc_event.dart';
part 'song_bloc_state.dart';

class SongBloc extends Bloc<SongBlocEvent, SongBlocState> {
  SongBloc() : super(SongBlocInitial()) {
    on<FetchSongEvent>(mapFetchSongEventToState, transformer: restartable());
  }
  SongProvider songProvider = SongProvider();
  void mapFetchSongEventToState(
      FetchSongEvent event, Emitter<SongBlocState> emit) async {
    emit(FetchingSongState());
    try {
      List<Song> songs = await songProvider.getSongs();
      emit(FetchedSongState(songs));
    } catch (error) {
      print(error);
      emit(FetchedSongErrorState());
    }
  }
}

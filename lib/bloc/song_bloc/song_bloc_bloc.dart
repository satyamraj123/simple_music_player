import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/repositories/song_repository.dart';

part 'song_bloc_event.dart';
part 'song_bloc_state.dart';

class SongBloc extends Bloc<SongBlocEvent, SongBlocState> {
  SongBloc() : super(SongBlocInitial()) {
    on<FetchSongEvent>(mapFetchSongEventToState);
  }
  final songRepository = SongRepository();
  void mapFetchSongEventToState(
      FetchSongEvent event, Emitter<SongBlocState> emit) async {
    emit(FetchingSongState());
    try {
      List<Song> songs = await songRepository.getSongs();
      emit(FetchedSongState(songs));
    } catch (error) {
      print(error);
      emit(FetchedSongErrorState());
    }
  }
}

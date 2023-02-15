import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/providers/song_provider.dart';
import 'package:simple_music_player/repositories/base_repository.dart';

class SongRepository extends BaseRepository {
  SongProvider songProvider = SongProvider();

  Future<List<Song>> getSongs() => songProvider.getSongs();
  @override
  void dispose() {
    songProvider.dispose();
  }
}

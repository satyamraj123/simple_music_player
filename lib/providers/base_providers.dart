import 'package:simple_music_player/models/song_model.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseSongProvider extends BaseProvider {
  Future<List<Song>> getSongs();
}

abstract class BaseSharedPreferencesProvider extends BaseProvider {
  Future<void> updateTopTracks(Song song);
  Future<void> intialiseTopTracks();
}
import 'dart:convert';
import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/providers/base_providers.dart';

class SharedPreferencesProvider extends BaseSharedPreferencesProvider {
  @override
  Future<void> updateTopTracks(Song song) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final List<Map<String,int>> topTracks=json.decode(prefs.getString('topTracks')!);
    
  }

 @override
  Future<void> intialiseTopTracks() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    if(prefs.containsKey('topTracks')==false){
      List<Map<String,int>> toptracks=[];
      prefs.setString('topTracks', json.encode(toptracks));
    }
  }

  @override
  void dispose() {}
}

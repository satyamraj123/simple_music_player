import 'dart:io';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/providers/base_providers.dart';

class SongProvider extends BaseSongProvider {
  @override
  Future<List<Song>> getSongs() async {
    Directory directory = Directory('/storage/emulated/0/Download');
    List<FileSystemEntity>? obj =
        await directory.list(recursive: true, followLinks: false).toList();
    List<String> pathlist = obj.map((FileSystemEntity e) => e.path).toList();
    pathlist = pathlist.where((element) => element.endsWith('.mp3')).toList();
    List<Song> songs = [];
    for (String e in pathlist) {
      try {
        songs.add(await convertJsonToSong(e));
      } catch (err) {
        continue;
      }
    }
    return songs;
  }

  @override
  void dispose() {}
  Audiotagger tagger = Audiotagger();
  Future<Song> convertJsonToSong(String e) async {
    var fileName = e.split('/').last.replaceFirst('.mp3', '');
    var title = fileName;
    var artist = 'Unknown';
    Widget cover = const Icon(Icons.music_note_outlined, color: Colors.white);
    var map = await tagger.readTagsAsMap(path: e);
    if (map != null) {
      if (map['title'] != null && map['title'] != '') {
        title = map['title'];
      }
      if (map['artist'] != null && map['artist'] != '') {
        artist = map['artist'];
      }
    }
    return Song(coverImage: cover, artist: artist, path: e, title: title);
  }
}

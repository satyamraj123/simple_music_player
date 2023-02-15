import 'dart:convert';
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/cupertino.dart';
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
        var fileName = e.split('/').last.replaceFirst('.mp3', '');
        var file = File(e);
        var title = fileName;
        var artist = 'Unknown';
        Widget cover = const Icon(Icons.music_note_outlined,color: Colors.white);
        List<Tag> tags =
            await TagProcessor().getTagsFromByteArray(file.readAsBytes());
        if (tags.isEmpty) {
          songs.add(Song(path: e, title: title, coverImage: cover));
          return songs;
        } else if (tags.length == 1) {
          if (tags[0].tags.containsKey('title')) {
            title = tags[0].tags['title'];
          }
          if (tags[0].tags.containsKey('artist')) {
            artist = tags[0].tags['artist'];
          }
          songs.add(
              Song(path: e, title: title, coverImage: cover, artist: artist));
        } else {
          if (tags[1].tags.containsKey('title')) {
            title = tags[1].tags['title'];
          }
          if (tags[1].tags.containsKey('artist')) {
            artist = tags[1].tags['artist'];
          }
          if (tags[1].tags.containsKey('picture')) {
            if (tags[1].tags['picture'].containsKey('Other')) {
              AttachedPicture pic = tags[1].tags['picture']['Other'];
              cover = Image.memory(base64Decode(pic.imageData64),fit: BoxFit.cover);
            }
          }
          songs.add(
              Song(coverImage: cover, title: title, path: e, artist: artist));
        }
      } catch (err) {
        print(err);
        continue;
      }
    }
    songs.sort((a,b)=>a.title.compareTo(b.title));
    return songs;
  }

  @override
  void dispose() {}
}

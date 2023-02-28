import 'dart:convert';
import 'dart:io';
import 'package:audiotagger/audiotagger.dart';

import '';
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
    // List<Song> songs =pathlist.map((e)=>Song(path: e)).toList();
    print(
        '##############################got songs path#########################33333');
    List<Song> songs = [];
    for (String e in pathlist) {
      try {
        songs.add(await convertJsonToSong(e));
      } catch (err) {
        print(err);
        continue;
      }
    }
    print(
        '##############################processed songs path#########################33333');
    // songs.sort((a,b)=>a.title.compareTo(b.title));
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
      // var bytes=await tagger.readArtwork(path: e);
      // if(bytes!=null){
      //   cover=Image.memory(bytes, fit: BoxFit.cover);
      // }
      if (map['title'] != null &&  map['title'] !='') {
        title = map['title'];
      }
      if (map['artist'] != null &&  map['artist'] !='') {
        artist = map['artist'];
      }
    }

    return Song(coverImage: cover, artist: artist, path: e, title: title);
    // final stopwatch = Stopwatch();
    // stopwatch.start();
    // List<Tag> tags =
    //     await TagProcessor().getTagsFromByteArray(file.readAsBytes());
    // print('read tags: ${stopwatch.elapsedMilliseconds}');
    // stopwatch.stop();
    // final stopwatch1 = Stopwatch();
    // stopwatch1.start();
    // if (tags.isEmpty) {
    //   return Song(path: e, title: title, coverImage: cover);
    // } else if (tags.length == 1) {
    //   if (tags[0].tags.containsKey('title')) {
    //     title = tags[0].tags['title'];
    //   }
    //   if (tags[0].tags.containsKey('artist')) {
    //     artist = tags[0].tags['artist'];
    //   }
    //   return Song(path: e, title: title, coverImage: cover, artist: artist);
    // } else {
    //   if (tags[1].tags.containsKey('title')) {
    //     title = tags[1].tags['title'];
    //   }
    //   if (tags[1].tags.containsKey('artist')) {
    //     artist = tags[1].tags['artist'];
    //   }
    //   if (tags[1].tags.containsKey('picture')) {
    //     if (tags[1].tags['picture'].containsKey('Other')) {
    //       AttachedPicture pic = tags[1].tags['picture']['Other'];
    //       cover =
    //           Image.memory(base64Decode(pic.imageData64), fit: BoxFit.cover);
    //     }
    //   }
    //   print('song created: ${stopwatch1.elapsedMilliseconds}');
    //     stopwatch1.stop();
    //   return Song(coverImage: cover, title: title, path: e, artist: artist);
    // }
  }
}

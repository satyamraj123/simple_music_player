import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/models/song_model.dart';
import 'package:simple_music_player/providers/base_providers.dart';

class Song {
  String title;
  String path;
  String artist;
  String duration;
  Widget coverImage;
  Song(
      {required this.title,
      required this.path,
      required this.coverImage,
      this.artist = 'Unknown Artist',
      this.duration = '0.0'});

}

// class Song {
//   String path;
//   Song({required this.path});
// }

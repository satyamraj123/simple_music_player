import 'package:flutter/cupertino.dart';

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

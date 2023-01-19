// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  Future<List<String>> getSongsFromDownloads()async{
    var status = await Permission.storage.status;
    var status1 = await Permission.manageExternalStorage.status;
    var status2 = await Permission.audio.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if (!status2.isGranted) {
      await Permission.audio.request();
    }
    Directory directory = Directory('/storage/emulated/0/Download');
    print(directory.path);
    List<FileSystemEntity>? obj =
        await directory.list(recursive: true, followLinks: false).toList();
List<String> pathlist=       obj.map((FileSystemEntity e) => e.path).toList();
    return obj.map((FileSystemEntity e) => e.path).toList();
  }
  void playSong(String path) async {
    player.setAudioSource(AudioSource.file(path));
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              getSongsFromDownloads();
            },
            child: Text('hello')),
      ),
    );
  }
}

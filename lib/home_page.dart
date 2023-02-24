// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc_bloc.dart';
import 'package:simple_music_player/bloc/song_bloc/song_bloc_bloc.dart';
import 'package:simple_music_player/ui/player_card.dart';
import 'package:simple_music_player/ui/song_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  late SongBloc songBloc;
  late PlayerBloc playerBloc;
  Future<List<String>> getSongsFromDownloads() async {
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
    List<String> pathlist = obj.map((FileSystemEntity e) => e.path).toList();
    return obj.map((FileSystemEntity e) => e.path).toList();
  }

  void playSong(String path) async {
    player.setAudioSource(AudioSource.file(path));
    player.play();
  }

  @override
  void initState() {
    songBloc = BlocProvider.of<SongBloc>(context);
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    songBloc.add(FetchSongEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SongBloc, SongBlocState>(builder: (context, state) {
          if (state is FetchingSongState) {
            return Center(child: Text('loading...'));
          } else if (state is FetchedSongErrorState) {
            return Center(
              child: Text('Error! cant find songs :('),
            );
          } else if (state is FetchedSongState) {
            if (state.songs.isEmpty) {
              return Center(
                child: Text('No songs in downloads:('),
              );
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Center(
                      child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text('Simple Music Player')),
                  )),
                  PlayerCard(playerBloc),
                  Container(
                    height: 20,
                    padding: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Text('${state.songs.length.toString()} Songs'),
                  ),
                  Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.songs.length,
                        itemBuilder: (ctx, i) => Container(
                                child: SongCard(
                              song: state.songs[i],
                              playerBloc: playerBloc,
                            ))),
                  ),
                ],
              ),
            );
          } else {
            return Center();
          }
        }),
      ),
    );
  }
}

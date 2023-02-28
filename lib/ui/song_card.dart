// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/bloc/song_bloc/song_bloc_bloc.dart';
import 'package:simple_music_player/models/song_model.dart';

import '../bloc/player_bloc/player_bloc_bloc.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final PlayerBloc playerBloc;
  const SongCard({super.key, required this.song, required this.playerBloc});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  bool currentSong = false;
  Widget coverImage = Container();
  bool isLoadingSong = true;
  Audiotagger tagger = Audiotagger();
  Future<void> getSongDetails(mounted) async {
    if (mounted) {
      setState(() {
        isLoadingSong = true;
      });
    }

    var bytes = await tagger.readArtwork(path: widget.song.path);
    if (bytes != null) {
      coverImage = Image.memory(bytes, fit: BoxFit.cover);
    } else {
      coverImage = const Icon(Icons.music_note_outlined, color: Colors.white);
    }
    if (mounted) {
      setState(() {
        isLoadingSong = false;
      });
    }
  }

  @override
  void initState() {
    if (mounted) {
      getSongDetails(mounted);
      // WidgetsBinding.instance.addPostFrameCallback((_) => getSongDetails());
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerBlocState>(
      listener: ((context, state) {
        if (state is PlayingState) {
          // if (state.currentSong.path.compareTo(widget.song.path) == 0) {
          //   setState(() {
          //     currentPosition = state.currentPosition;
          //   });
          // }
        } else if (state is PausedState) {
          // setState(() {
          //   currentSongPaused = true;
          // });
        } else if (state is ChangedSongState) {
          if (state.currentSong.path.compareTo(widget.song.path) == 0) {
            setState(() {
              currentSong = true;
              // currentPosition = Duration(seconds: 0);
            });
          } else {
            setState(() {
              currentSong = false;
              // currentPosition = Duration(seconds: 0);
            });
          }
        }
      }),
      child: GestureDetector(
        onTap: () async {
          widget.playerBloc
              .add(ChangeSongEvent(widget.song, Duration(seconds: 0)));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey,
                  child: isLoadingSong ? widget.song.coverImage : coverImage),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.song.title,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: currentSong
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                      Text(
                        widget.song.artist,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: currentSong
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              // Text(currentPosition.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

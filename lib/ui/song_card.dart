// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/models/song_model.dart';

import '../bloc/player_bloc/player_bloc_bloc.dart';

class SongCard extends StatefulWidget {
  final Song song;
  const SongCard({super.key, required this.song});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  late PlayerBloc playerBloc = BlocProvider.of<PlayerBloc>(context);
  bool currentSong = false;
  bool currentSongPaused = false;
  Duration currentPosition = Duration(seconds: 0);
  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerBlocState>(
      listener: ((context, state) {
        if (state is PlayingState) {
          if (state.currentSong.path == widget.song.path) {
            setState(() {
              currentSong = true;
              currentPosition = state.currentPosition;
            });
          } else {
              setState(() {
                currentSong = false;
                currentPosition = Duration(seconds: 0);
              });
            
          }
        } else if (state is PausedState) {
          setState(() {
            currentSongPaused = true;
          });
        }
      }),
      child: GestureDetector(
        onTap: () async {
          if (currentSong) {
            if (currentSongPaused) {
              playerBloc.add(ChangeSongEvent(widget.song, currentPosition));
              setState(() {
                currentSongPaused = false;
              });
            } else {
              playerBloc.add(PauseSongEvent(widget.song));
            }
          } else {
            playerBloc.add(ChangeSongEvent(widget.song, Duration(seconds: 0)));
            setState(() {
              currentSongPaused = false;
            });
          }
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
                  child: widget.song.coverImage),
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
              Text(currentPosition.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc_bloc.dart';
import 'package:simple_music_player/models/song_model.dart';

class PlayerCard extends StatefulWidget {
  final PlayerBloc playerBloc;
const PlayerCard(this.playerBloc, {super.key});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  Duration totalDuration = Duration(seconds: 0);
  Duration currentDuration = Duration(seconds: 0);
  String songName = '';
  String songArtist = '';
  List<Song> songStack=[];
  int currentSongPointer=-1;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerBlocState>(
      listener: (context, state) {
        if (state is PlayingState) {
          setState(() {
            currentDuration = state.currentPosition;
          });
        } else if (state is ChangedSongState) {
          print('heloo###################################################');
          setState(() {
            songName = state.currentSong.title;
            totalDuration = state.totalDuration;
            songStack.add(state.currentSong);
            currentSongPointer=0;
          });
        }
      },
      child: totalDuration.inSeconds == 0
          ? noSongPayerCard()
          : SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              widget.playerBloc.add(PauseSongEvent(songStack[currentSongPointer]));
                            },
                            icon: Icon(Icons.play_arrow))
                      ],
                    ),
                    totalDuration.inSeconds == 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ProgressBar(
                              baseBarColor: Colors.grey,
                              thumbColor: Colors.black,
                              progressBarColor: Colors.black,
                              progress: currentDuration,
                              total: totalDuration,
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget noSongPayerCard() {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                IconButton(onPressed: null, icon: Icon(Icons.skip_previous)),
                IconButton(onPressed: null, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: null, icon: Icon(Icons.skip_next))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc_bloc.dart';
import 'package:simple_music_player/bloc/song_bloc/song_bloc_bloc.dart';
import 'package:simple_music_player/home_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      BlocProvider<SongBloc>(create: (context)=> SongBloc()),
      BlocProvider<PlayerBloc>(create: (context)=> PlayerBloc())
    ],
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_player/tracks.dart';

import 'music_player.dart';

void main() {
  runApp(MaterialApp(

    home: Tracks(),

        routes: {

    '/tracks': (context) => Tracks(),
    '/music_player': (context) => MusicPlayer(),


        },


  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracks();
  }
}


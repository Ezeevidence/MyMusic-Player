import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import 'music_player.dart';


class Tracks extends StatefulWidget {
  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  final GlobalKey<_MusicPlayerState> key = GlobalKey<_MusicPlayerState>();



  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if(isNext) {
      if(currentIndex != songs.length-1) {
        currentIndex++;
      }else {
        if(currentIndex !=0) {
          currentIndex--;
        }
      }
    }
    key.currentState.setSong(songs[currentIndex]);

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("MyMusic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),

      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: songs[index].albumArtwork == null? AssetImage('assets/pic.png'):FileImage(File(songs[index].albumArtwork)),
            ),
            title: Text(songs[index].title),
            subtitle: Text(songs[index].artist),
            onTap: () {
              currentIndex = index;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MusicPlayer(songInfo: songs[currentIndex], changeTrack: changeTrack, key:key)));

            },
          ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: songs.length

      ),
    );
  }
}

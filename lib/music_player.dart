import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {

  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<_MusicPlayerState> key;

  MusicPlayer({this.songInfo, this.changeTrack, this.key}):super(key:key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  double minimumValue = 0.0, currentValue = 0.0, maximumValue = 0.0;
  String currentTime = '', endTime = '';


  final AudioPlayer player = AudioPlayer();
  Function changeTrack;


  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      setSong(widget.songInfo);
    });
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo=songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    isPlaying = false;
    changeStatus();
    
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getduration(currentValue);
      });
    });

    setState(() {
      currentTime = getduration(currentValue);
      endTime = getduration(maximumValue);
    });

  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if(isPlaying) {
      player.play();
    }else {
      player.pause();
    }
  }


  String getduration(double value){
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds].map((element) => element.remainder(60).toString().padLeft(2, '0')).join(':');


  }

  bool isPlaying = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Now Playing"),
        backgroundColor: Colors.redAccent,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.of(context).pop();
        }),
      ),


      body: Container(
        margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: widget.songInfo.albumArtwork == null? AssetImage('assets/pic.png'):FileImage(File(widget.songInfo.albumArtwork)), radius: 95,
            ),
            
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 7),
              child: Text(widget.songInfo.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.black54),),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(widget.songInfo.artist,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5, color: Colors.grey
                ),),
            ),

            Slider( inactiveColor: Colors.black,
              activeColor: Colors.black12,
              min: minimumValue,
              max: maximumValue,
              value: currentValue,
              onChanged: (value) {
              currentTime = value as String;
              player.seek(Duration(milliseconds: currentValue.round()));
              },
                ),

            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 6, 15),
              transform: Matrix4.translationValues(0, -7, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currentTime,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.black54),
                  ),
                  Text(endTime,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.black54),),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              transform: Matrix4.translationValues(0, -5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  GestureDetector(
                    child: IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.black, size: 55,),
                        onPressed: null),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.changeTrack(false);

                    },
                  ),

                  GestureDetector(
                    child: IconButton(
                        icon: Icon(isPlaying? Icons.pause_circle_filled:Icons.play_circle_filled, color: Colors.black, size: 55,),
                        onPressed: null),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {

                    },
                  ),

                  GestureDetector(
                    child: IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.black, size: 55,),
                        onPressed: null),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.changeTrack(true);

                    },
                  )

                ],
              ),
            ),

          ],
        ),

      ),
    );
  }
}

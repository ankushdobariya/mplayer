import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playsong extends StatefulWidget {
  List? currentsong;
  int aa;

  playsong(this.currentsong, this.aa);

  @override
  _playsongState createState() => _playsongState();
}

class _playsongState extends State<playsong> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool song = false;
  String? localpath;
  int dvalue = 0;
  double position = 0;
  double duration = 0;
  bool get = false;

  getdata() async {
    localpath = widget.currentsong![widget.aa].data;
    await audioPlayer.play(localpath!, isLocal: true);

    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() {
        dvalue = d.inMilliseconds;
        get = true;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        widget.aa = widget.aa + 1;
      });
      getdata();
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.currentsong![widget.aa].title),
          ),
          ListTile(
            title: Text(widget.currentsong![widget.aa].displayName),
          ),
          Container(
            height: 400,
            width: 300,
            color: Colors.grey,
          ),
          Slider(
              onChanged: (value) async {
                await audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
              value: position,
              min: 0,
              max: dvalue.toDouble()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    if (widget.aa > 0) {
                      await audioPlayer.stop();
                      widget.aa = widget.aa - 1;
                      localpath = widget.currentsong![widget.aa].data;
                      await audioPlayer.play(localpath!, isLocal: true);
                    }
                    setState(() {});
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined)),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      song = !song;
                    });
                    if (song) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                  icon: song ? Icon(Icons.play_arrow) : Icon(Icons.pause)),
              IconButton(
                  onPressed: () async {
                    if (widget.aa > 0) {
                      await audioPlayer.stop();
                      widget.aa = widget.aa + 1;
                      localpath = widget.currentsong![widget.aa].data;
                      await audioPlayer.play(localpath!, isLocal: true);
                    }
                    setState(() {});
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
        ],
      ),
    );
  }
}
//

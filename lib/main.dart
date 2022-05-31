import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'musicpage.dart';

void main()
{
  runApp(MaterialApp(home: demo(),));
}
class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  _demoState createState() => _demoState();
}

class _demoState extends State<demo> {

  bool getdata=false;
  List<SongModel> songlist=[];
  OnAudioQuery _audioQuery = OnAudioQuery();

  someName() async {
    songlist = await _audioQuery.querySongs();

    setState(() {
      getdata=true;

    });
  }
  permission()
  async {
    if (await Permission.storage.request().isGranted) {
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);

    var status = await Permission.storage.status;
    if (status.isDenied) {

      permission();
    }

// You can can also directly ask the permission about its status.
    if (await Permission.storage.isRestricted) {

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    someName();
    permission();
  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Songs"),),
        body: getdata?ListView.builder(
          itemCount: songlist.length,
          itemBuilder: (context, index) {
            print("${songlist[index].title}==${songlist[index].displayName}");
            return ListTile(
              title: Text("${songlist[index].title}"),
              trailing: Text(_printDuration(Duration(milliseconds: songlist[index].duration!))),
              // subtitle: Text("${songlist[index].displayName}"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return playsong(songlist,index);
                },));
              },
            );
          },):Center(child: CircularProgressIndicator(),)
    );
  }
}

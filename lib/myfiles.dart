import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/side_nav.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final Directory _photoDir = Directory(
    '/storage/emulated/0/Android/data/com.webdevwithus.flutter_app/files'); //change to audio folder
//var imageList = _photoDir.listSync().map((item) => item.path).where((
//    item) => item.endsWith(".mp4")).toList(growable: false); // add .mp4 format

class Photos extends StatefulWidget {
  @override
  PhotosState createState() {
    return new PhotosState();
  }
}

class PhotosState extends State {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
//  bool flag=false;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_photoDir.path}").existsSync()) {
      return Scaffold(
        drawer: NavDrawer(context, 0),
        backgroundColor: HexColor('#182035'),
        appBar: AppBar(
          title: Text("Audio Books"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 60.0),
          child: Center(
            child: Text(
              "All your Audio books will appear here",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      );
    } else {
      var imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);

      if (imageList.length > 0) {
        return Scaffold(
          backgroundColor: HexColor('#182035'),
          drawer: NavDrawer(context, 0),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Audio Books"),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 60.0),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
//              crossAxisCount: 4,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                bool flag;
                String imgPath = imageList[index];
                var filename = imgPath.split("/").last.split(".").first;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
//        isThreeLine: true,
                      leading: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 30,
                            color: HexColor('#182035'),
                          )),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            filename,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
//                      subtitle: Text(appDisc),//TODO:file size
                      trailing: Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            flag == true
                                ? IconButton(
                                    icon: Icon(Icons.pause),
                                    color: HexColor('#182035'),
                                    onPressed: () async {
                                      await audioPlayer.pause();
                                      setState(() {
                                        flag = false;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    color: HexColor('#182035'),
                                    onPressed: () async {
                                      await audioPlayer.play(imgPath,
                                          isLocal: true);
                                      setState(() {
                                        flag = true;
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ),
//trailing
//                      onTap: () => isAppInstalled(packName),
//                      onLongPress: () => launchURL("https://forms.gle/THdWphvSvECLfjx27"),
                    ),
                  ),
                );
//                return Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: [
//
//
//
//                    SizedBox(height: 20),
//                    Text(filename,style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20
//                    ),),
//                    SizedBox(height: 10),
//
//                    RaisedButton(
//                        child: Icon(
//                          Icons.play_arrow,
//                          color: HexColor('#182035'),
//                        ),
//                        onPressed: () async{
//                          print(imgPath);
//
//                            await audioPlayer.play(imgPath, isLocal: true);
//
//                        }),
//
//                    SizedBox(height: 30),
//
////                    getLocalFileDuration(),
//                  ],
//                );
//                return Material(
//                  elevation: 8.0,
//                  borderRadius: BorderRadius.all(Radius.circular(8)),
//                  child: InkWell(
//                    onTap: () {},
//                    child: Hero(
//                      tag: imgPath,
//                      child: Image.file(
//                        File(imgPath),
//                        fit: BoxFit.cover,
//                      ),
//                    ),
//                  ),
//                );
              },
//              staggeredTileBuilder: (i) =>
//                  StaggeredTile.count(2, i.isEven ? 2 : 3),
//              mainAxisSpacing: 8.0,
//              crossAxisSpacing: 8.0,
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: HexColor('#182035'),
          drawer: NavDrawer(context, 0),
          appBar: AppBar(
            title: Text("Audio Files"),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Text(
                "Sorry, No Audio Files Found !",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        );
      }
    }
  }
}

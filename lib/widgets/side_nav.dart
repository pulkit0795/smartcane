import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ocr_app/main2.dart';
import 'package:ocr_app/main.dart';
//import 'package:ocr_app/camera.dart';

  Widget NavDrawer(BuildContext context, int num) {
    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Smart Cane',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: HexColor('#182035'),
                ),
          ),
          ListTile(
            selected: num==0 ? true : false,


            leading: Icon(Icons.input),
            title: Text('Text to Speech'),
            onTap: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()))},
          ),
          ListTile(
            selected: num==1? true : false,
            leading: Icon(Icons.verified_user),
            title: Text('Image to Speech'),
            onTap: ()  => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FlutterVisionHome()))},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('My Files'),
            onTap: () => {Navigator.of(context).pop()},

          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Test Camera'),
//            onTap: () => {
//              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> CameraApp())),
//            on()
//            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Developers'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }

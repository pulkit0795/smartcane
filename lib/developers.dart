import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ocr_app/widgets/side_nav.dart';

class Developers extends StatefulWidget {
  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(context,2),
      backgroundColor: HexColor('#2f3649'),
      appBar: AppBar(
        title: Text(
          'Developers',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MENTOR',
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 33.0,
                  child: CircleAvatar(
                  backgroundImage:AssetImage('lib/assets/mentor.jpeg') ,
                    radius: 30.0,
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  'Dr Mukesh Mann',
                  style: TextStyle(color: Colors.white,fontSize: 16,),
                )
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Divider(
                        color: Colors.blueGrey,
                        height: 50,
                      )),
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CORE DEVELOPERS TEAM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 33.0,
                  child: CircleAvatar(
                    backgroundImage:AssetImage('lib/assets/sid.jpeg') ,
                    radius: 30.0,
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  'Siddhant Tiwari',
                  style: TextStyle(color: Colors.white,fontSize: 16,),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 33.0,
                  child: CircleAvatar(
                    backgroundImage:AssetImage('lib/assets/pranati.jpeg') ,
                    radius: 30.0,
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  'Pranati Gupta',
                  style: TextStyle(color: Colors.white,fontSize: 16,),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 33.0,
                  child: CircleAvatar(
                    backgroundImage:AssetImage('lib/assets/pulkit.jpeg') ,
                    radius: 30.0,
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  'Pulkit Goyal',
                  style: TextStyle(color: Colors.white,fontSize: 16,),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

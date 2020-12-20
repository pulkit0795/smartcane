
import 'dart:async';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'main.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'widgets/side_nav.dart';
import 'package:ocr_app/main.dart';


//main(){
//  WidgetsFlutterBinding.ensureInitialized();
//  runApp(FlutterVisionApp());
//}

//class FlutterVisionApp extends StatelessWidget {
//
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: FlutterVisionHome(),
//      theme: ThemeData(
//        primaryColor: HexColor('#182035')
//      ),
//    );
//  }
//}

class FlutterVisionHome extends StatefulWidget {
  @override
  _FlutterVisionHomeState createState() => _FlutterVisionHomeState();
}

class _FlutterVisionHomeState extends State<FlutterVisionHome> {

//  int num=1;
  String text;
  String ftext=' ';
  final FlutterTts flutterTts = FlutterTts();
  String imagePath;

  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(context,1),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Image Labeller")
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: _imageList(),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _imageList()
  {
    return GestureDetector(
      child: Center(
        child: Image.asset("lib/Assets/draw.jpg"),
      ),
        onTap: () async{
        print("detecting");
        String file= await getImageFileFromAssets("draw.jpg");
        print(file);
        setState(() {
          imagePath= file;
        });
        detectLabels();
    },
    );
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> getImageFileFromAssets(String path) async{
    final byteData = await rootBundle.load('lib/Assets/$path');
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath= '${extDir.path}/Pictures/flutter_vision';
    await Directory(dirPath).create(recursive: true);
    final String filePath='$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    final file= File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return filePath;
  }

  Future<void> detectLabels() async{
    ftext='';

    final FirebaseVisionImage visionImage= FirebaseVisionImage.fromFilePath(imagePath);
    final ImageLabeler labelDetector = FirebaseVision.instance.imageLabeler(
      ImageLabelerOptions(confidenceThreshold: 0.50)
    );
    final List<ImageLabel> labels= await labelDetector.processImage(visionImage);

    for(ImageLabel label in labels){
      text =label.text;
      text= text.toString();
      print(text);
//      text= text + ' ';
      ftext+=' ';
      ftext+=text;


//      await flutterTts.speak(text);
//      print(text);


//      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));

    }
//    print(text);
    print(ftext);
    await flutterTts.speak(ftext);
  }
}


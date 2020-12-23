import 'dart:async';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'main.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'widgets/side_nav.dart';
import 'package:image_picker/image_picker.dart';
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
  CameraController controller;

//  int num=1;
  String text;
  File pickedImage;
  String ftext = ' ';
  final FlutterTts flutterTts = FlutterTts();
  String imagePath;

  Future pickImage(bool cam) async {
    var tempStore = cam
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    print(tempStore);

    setState(() {
      pickedImage =
          tempStore; // picked image wali file ko rotate krna h or fir picked img e hi save kradena h
//      isImageLoaded = true;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: HexColor('#182035'),
      drawer: NavDrawer(context, 1),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Image Labeller"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: (size / 1.15) - 40,
            height: (size / 1) - 100,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: pickedImage != null ? _imageList() : Container(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: RaisedButton(
              elevation: 6,
              color: HexColor('#161D2F'),
              hoverColor: HexColor('#182035'),
              splashColor: Colors.white70,
              child: Text(
                'Choose Image',
                style: TextStyle(
                    fontSize: 15, letterSpacing: 2, color: Colors.white),
              ),
              onPressed: () {
                pickImage(false);
              },
              onLongPress: () {
                pickImage(true);
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
//    TwinkleButton(
//    buttonTitle: Text(
//    'Click on the Image',
//    style: TextStyle(
//    color: Colors.white,
//    fontWeight: FontWeight.w300,
//    fontSize: 20.0,
//    ),
//    ),
//    buttonColor: Colors.yellow,
//
//    highlightColor: HexColor('#182035'),
//    onclickButtonFunction: () {
//    print('hello');
//    }
//    )
        ],
      ),
    );
  }

  Widget _imageList() {
    return GestureDetector(
      child: Center(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: FileImage(pickedImage), fit: BoxFit.fill)),
      )),
      onTap: () async {
        print("detecting");
        String file = pickedImage.path; //picked image
        print(file);
        setState(() {
          imagePath = file;
        });
        detectLabels();
      },
    );
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('lib/Assets/$path');
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_vision';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return filePath;
  }

  Future<void> detectLabels() async {
    ftext = 'I have identified: ';

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(imagePath);
    final ImageLabeler labelDetector = FirebaseVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.50));
    final List<ImageLabel> labels =
        await labelDetector.processImage(visionImage);

    for (ImageLabel label in labels) {
      text = label.text;
      text = text.toString();
      print(text);
//      text= text + ' ';
      ftext += ' ,';
      ftext += text;

//      await flutterTts.speak(text);
//      print(text);

//      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));

    }
//    print(text);
    print(ftext);
//    await flutterTts.setSpeechRate(0.2);
    await flutterTts.speak(ftext);
  }
}

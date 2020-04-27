import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plants/info_plant.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading;
  File _image;
  List _output;
  String _inf;
  String _te;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plants"),
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ):SingleChildScrollView( child: Container(
        child: Column(
          children: [
            _image == null ? Container():Image.file(_image, width: 500, height:500),
            SizedBox(
              height:16,
            ),
            _output == null ? Text("Check your plant"): Text("${_output[0]["label"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            _inf == null ? Text(""): Text(_inf.toString()),
            _te == null ? Text(""): Text(_te.toString()),
          ],
        ),
      ),scrollDirection: Axis.vertical,
          reverse:false
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child:Icon(Icons.image),
            label: "Gallery",
            onTap: (){
              chooseImageGallery();
            }
          ),
          SpeedDialChild(
              child:Icon(Icons.camera),
              label: "Camera",
              onTap: (){
                chooseImageCamera();
              }
          )

        ]
      ),
    );
  }


  chooseImageGallery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });
    runModelOnImage(image);
  }

  chooseImageCamera() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });
    runModelOnImage(image);
  }


  runModelOnImage(File image)async{
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.1
    );
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

}
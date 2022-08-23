
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker imagePicker;
  File? _image;
  String result = '';
  //TODO declare scanner
  late BarcodeScanner barcodeScanner;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //TODO initialize scanner
    barcodeScanner = BarcodeScanner();
  }


  @override
  void dispose() {
      barcodeScanner.close();
  }

  _imgFromCamera() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doBarcodeScanning();
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
      doBarcodeScanning();
    });
  }

  //TODO barcode scanning code here
  doBarcodeScanning() async{
    final inputImage = InputImage.fromFile(_image!);
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
    result = "";
    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      // final Rect boundingBox = barcode.boundingBox;
      // final String displayValue = barcode.value?.displayValue;
      // final String rawValue = barcode.value.rawValue;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi barcodeWifi = barcode.value as BarcodeWifi;
          setState(() {
            result += "Wifi:"+barcodeWifi.ssid!+"\n"+barcodeWifi.password!;
          });
          break;
        case BarcodeType.url:
          BarcodeUrl barcodeUrl = barcode.value as BarcodeUrl;
          setState(() {
            result += "URL:"+barcodeUrl.title!+"\n"+barcodeUrl.url!;
          });
          break;
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/wall2.jpg'), fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Stack(children: <Widget>[
                      Stack(children: <Widget>[
                        Center(
                          child: Image.asset(
                            'images/sframe.jpg',
                            height: 220,
                            width: 220,
                          ),
                        ),
                      ]),
                      Center(
                        child: FlatButton(
                          onPressed: _imgFromGallery,
                          onLongPress: _imgFromCamera,
                          child: Container(
                            margin: EdgeInsets.only(top: 14),

                            child: _image != null
                                ? Image.file(
                              _image!,
                              width: 195,
                              height: 193,
                              fit: BoxFit.fill,

                            )
                                : Container(
                              width: 140,
                              height: 150,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  // Container(margin:EdgeInsets.only(top:300,right: 80),child: Center(
                  //
                  // )),
                  Container(margin:EdgeInsets.only(top: 20),child: Text('$result',textAlign:TextAlign.center,style: TextStyle(fontFamily: 'finger_paint',fontSize: 30),),),

                ],
              ),
            )));

  }
}

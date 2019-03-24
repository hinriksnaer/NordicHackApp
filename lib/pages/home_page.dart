import 'dart:convert';
import 'package:barcode_scan_example/pages/task.dart';
import 'package:barcode_scan_example/pages/task_row.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan_example/pages/animated_fab.dart';
import 'package:barcode_scan_example/pages/diagonal_clipper.dart';
import 'package:barcode_scan_example/pages/list_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../widget/bottom_info.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final double _imageHeight = 256.0;
  List<Task> taskList = new List<Task>();
  bool showOnlyCompleted = false;
  String scanTypeText = 'Food Allergy';
  String barcode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleImageScan(scanTypeText);
        },
        child: Icon(Icons.camera_alt),
      ),
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(),
          BottomInfo(scanTypeText, taskList),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(
          onClick: _changeFilterState,
        ));
  }

  void _changeFilterState(String scanTypeText) {
    setState(() {
      this.scanTypeText = scanTypeText;
    });
  }

  Widget _buildIamge() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'images/birds.jpg',
          fit: BoxFit.cover,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileRow() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundImage: new AssetImage('images/avatar.jpg'),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  'Helgi Grétar',
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                new Text(
                  '',
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  Future _scan(String scanType) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  List<Task> parsedBarcodeData(Map data) {
    List<Task> tasks = new List<Task>();      
        tasks.add(new Task(category: '', name: data['medication']['name'], completed: true)); 
        tasks.add(new Task(category: data['medication']['directions'], name: 'Instructions', completed: true));
        tasks.add(new Task(category: data['medication']['quantity'], name: 'Quantity', completed: true));
        tasks.add(new Task(category: data['medication']['daysleft'], name: 'days Left', completed: true));

    return tasks;
  }

  void _handleImageScan(String scanType) async {
    print(scanType);
    if (scanType == 'Drug Allergy') {
      await _scan(scanType);
      Map data = await _getAllergyInformation(barcode);  
    
      setState(() {
        this.taskList = parsedBarcodeData(data);
      });
    } else if (scanType == 'Drug Text') {
      File image = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      _uploadImage(image);
    } else if (scanType == 'Food Allergy'){
      //todo
    }
    

  }

  Future<Map> _getAllergyInformation(String barcode) async {
    final Map<String, dynamic> allergyData = {'barcode': barcode};

    final http.Response response = await http.post(
        'https://nordichealth-heroku.herokuapp.com/medication',
        body: json.encode(allergyData),
        headers: {'Content-Type': 'application/json'});

    return json.decode(response.body);
  }

  void _uploadImage(File image) async {
    try {
      if (image == null) return;
      String base64Image = base64Encode(image.readAsBytesSync());
      String fileName = image.path.split("/").last;
      http.Response response = await http
          .post('https://nordichealth-heroku.herokuapp.com/image', body: {
        "image": base64Image,
        "name": fileName,
      });
      print(response.statusCode);
      print(json.decode(response.body));
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:flutter/material.dart';

import './scan.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('no idea what this is'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ScanPage()));
          },
          child: Text('Scan Medication'),
        ),
      ),
    );
  }
}
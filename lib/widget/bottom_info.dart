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

class BottomInfo extends StatelessWidget {

  final String scanTypeText;
  final Map listData;
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();

  BottomInfo(this.scanTypeText, this.listData);

  @override
  Widget build(BuildContext context) {
    final double _imageHeight = 256.0;

    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    ListModel listModel;

    return new Expanded(
      child: new AnimatedList(
       // initialItemCount: tasks.length, 
        key: _listKey,
        itemBuilder: (context, index, animation) {
          print("${listData}Þetta er helvítis datað");
          listModel.insert(index, listData['name'], listData['category']);

          return new TaskRow(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            scanTypeText,
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            'Bjarkargrund 31, 300 Akranes',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

}
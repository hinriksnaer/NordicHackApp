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
class listinn {
  String name;
  String category;  
}
class BottomInfo extends StatelessWidget {
     
  final String scanTypeText;
  final List<Task> listTasks;
  final GlobalKey<AnimatedListState> _listKeys =
      new GlobalKey<AnimatedListState>();

  BottomInfo(this.scanTypeText, this.listTasks);

  @override
  Widget build(BuildContext context) {
    final double _imageHeight = 130.0;

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
          initialItemCount: listTasks.length, 
          key: _listKeys,
          itemBuilder: (context, index, animation) {
            return new TaskRow(
              task: listTasks[index],
              animations: animation,
            );
          },
        ),
      );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 32.0,bottom: 0.0), 
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            scanTypeText,
            style: new TextStyle(fontSize: 30.0),
          ),
          
        ],
      ),
    );
  }

}
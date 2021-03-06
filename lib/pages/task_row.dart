import 'package:barcode_scan_example/pages/task.dart';
import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final double dotSize = 12.0;
  final Animation<double> animations;
  final Function onClick;

  const TaskRow({Key key, this.task, this.animations, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onClick,
      child: new FadeTransition(
        opacity: animations,
        child: new SizeTransition(
          sizeFactor: animations,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 0.0),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        task.name,
                        style: new TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w600),
                      ),
                      new Text(
                        task.category,
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

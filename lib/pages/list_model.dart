import 'package:barcode_scan_example/pages/task.dart';
import 'package:barcode_scan_example/pages/task_row.dart';
import 'package:flutter/material.dart';

class ListModel {
  ListModel(this.listKeys, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKeys;
  final List<Task> items;

  AnimatedListState get _animatedList => listKeys.currentState;

  void insert(int index, Task task) {  
    items.insert(index, task);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) => new TaskRow(
              task: removedItem,
              animations: animation,
            ),
        duration: new Duration(milliseconds: (150 + 200*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Task operator [](int index) => items[index];

  int indexOf(Task item) => items.indexOf(item);
}

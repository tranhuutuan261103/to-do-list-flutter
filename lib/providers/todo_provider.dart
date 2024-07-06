import 'package:flutter/material.dart';

import '../model/todo.dart';

class ToDoProvider extends ChangeNotifier {
  final List<ToDo> _toDoList = [];

  List<ToDo> get toDoList => _toDoList;

  // init todo state
  void initToDoList(List<ToDo> toDoList) {
    _toDoList.addAll(toDoList);
    notifyListeners();
  }

  void addToDoItem(ToDo item) {
    _toDoList.add(item);
    print('Added: ${item.title}');
    notifyListeners();
  }

  void removeToDoItem(ToDo item) {
    _toDoList.remove(item);
    notifyListeners();
  }

  void toggleToDoStatus(ToDo item) {
    final index = _toDoList.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _toDoList[index].isCompleted = !_toDoList[index].isCompleted;
      notifyListeners();
    }
  }
}
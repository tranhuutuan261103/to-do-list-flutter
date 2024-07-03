import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(ToDo) onToDoDeleted;

  // ignore: use_super_parameters
  const ToDoItem({Key? key, required this.todo, required this.onToDoChanged, required this.onToDoDeleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
          onTap: () => onToDoChanged(todo),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          tileColor: Colors.white,
          leading: Icon(
              todo.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: tdBlue),
          title: Text(todo.title,
              style: TextStyle(
                  color: tdBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none)),
          trailing: Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: tdRed,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 35,
            width: 35,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              iconSize: 18,
              onPressed: () => onToDoDeleted(todo),
            ),
          )),
    );
  }
}

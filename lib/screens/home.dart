import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatelessWidget {
  // ignore: use_super_parameters
  Home({Key? key}) : super(key: key);

  final todoList = ToDo.todoList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            children: [
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: const Text('All Todos',
                          style: TextStyle(
                              fontSize: 30,
                              color: tdBlack,
                              fontWeight: FontWeight.w500)),
                    ),
                    ...todoList
                        .map((todo) => ToDoItem(
                              key: ValueKey(todo.id),
                              todo: todo,))
                  ],
              ))
            ],
          ),
        ));
  }
}

Widget searchBox() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
        prefixIconConstraints: BoxConstraints(minWidth: 25, maxHeight: 20),
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(color: tdGrey),
      ),
    ),
  );
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: tdBGColor,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
          ),
        ),
      ],
    ),
  );
}

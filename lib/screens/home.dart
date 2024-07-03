import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  // ignore: use_super_parameters
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _filteredList = [];
  final _toDoController = TextEditingController();

  @override
  void initState() {
    _filteredList = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Container(
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
                      ..._filteredList.map((todo) => ToDoItem(
                            key: ValueKey(todo.id),
                            todo: todo,
                            onToDoChanged: _handleToDoChange,
                            onToDoDeleted: _handleDeleteToDoItem,
                          ))
                    ],
                  ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _toDoController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: 'Add a new task',
                              hintStyle: TextStyle(color: tdGrey),
                            ),
                          ))),
                  Container(
                    margin: const EdgeInsets.only(right: 20, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => _addToDoItem(_toDoController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tdBlue,
                        minimumSize: const Size(60, 60),
                        elevation: 10,
                      ),
                      child: const Text('+',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _handleDeleteToDoItem(ToDo todoDeleted) {
    setState(() {
      todoList.removeWhere((todo) => todo.id == todoDeleted.id);
    });
  }

  void _addToDoItem(String toDoTitle) {
    setState(() {
      final newToDo = ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: toDoTitle,
        isCompleted: false,
      );
      todoList.add(newToDo);
    });
    _toDoController.clear();
  }

  void _filterList(String query) {
    setState(() {
      _filteredList = todoList
          .where((todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) => _filterList(value),
        decoration: const InputDecoration(
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
}

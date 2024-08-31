import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/todo_provider.dart';

import "../screens/home.dart";
import '../screens/code_editor.dart';
import '../screens/code_viewer.dart';
import '../services/todo_service.dart';

class AppRoutes extends StatefulWidget {
  const AppRoutes({super.key});

  @override
  State<AppRoutes> createState() => _AppRoutesState();
}

class _AppRoutesState extends State<AppRoutes> {
  int currentTab = 0;
  final List<Widget> screens = [
    const Home(),
    const CodeEditor(),
    const CodeViewer(),
    const Placeholder(),
  ];

  final pageStorageBucket = PageStorageBucket();
  Widget currentScreen = const Home();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final todoService = ToDoService();
    final data = await todoService.getToDoList();
    if (mounted) {
      context.read<ToDoProvider>().initToDoList(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentScreen,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          currentIndex: currentTab,
          onTap: (index) {
            setState(() {
              currentTab = index;
              currentScreen = screens[index];
            });
          },
          unselectedItemColor: const Color.fromARGB(255, 255, 226, 181), // Set the selected item color to red
          selectedItemColor: const Color.fromARGB(255, 254, 164, 10), // Set the unselected item color to red
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.code),
              label: 'Code Editor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.code),
              label: 'Code Viewer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

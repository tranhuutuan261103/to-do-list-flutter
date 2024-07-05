import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/todo_provider.dart';

import "../screens/home.dart";
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
    const Placeholder(),
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
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            currentScreen = screens[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
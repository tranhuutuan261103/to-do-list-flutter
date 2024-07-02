import 'package:flutter/material.dart';
import 'package:to_do_list/constants/colors.dart';

class Home extends StatelessWidget {
  // ignore: use_super_parameters
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Text('This is a Home Page'),
    );
  }
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
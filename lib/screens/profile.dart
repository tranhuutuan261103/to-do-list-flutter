import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import './re_editor/editor_autocomplete.dart';
import './re_editor/editor_basic_field.dart';
import './re_editor/editor_json.dart';
import './re_editor/editor_python.dart';
import './re_editor/editor_large_text.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const Map<String, Widget> _editors = {
    'Basic Field': BasicField(),
    'Json Editor': JsonEditor(),
    'Python Editor': PythonEditor(),
    'Auto Complete': AutoCompleteEditor(),
    'Large Text': LargeTextEditor(),
  };

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final Widget child = _editors.values.elementAt(_index);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _editors.entries.mapIndexed((index, entry) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          _index = index;
                        });
                      },
                      child: Text(
                        entry.key,
                        style: TextStyle(
                            color: _index == index ? null : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                  child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: child,
              ))
            ],
          )),
    );
  }
}

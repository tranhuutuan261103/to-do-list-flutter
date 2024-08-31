import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodeViewer extends StatefulWidget {
  const CodeViewer({super.key});

  @override
  State<CodeViewer> createState() => _CodeViewerState();
}

class _CodeViewerState extends State<CodeViewer> {
  Highlighter? highlighter;

  // The code string to be highlighted
  final myCodeString = '''
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import './routes/app_routes.dart';
import './providers/todo_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Highlighter.initialize(['dart', 'yaml', 'sql']);
  runApp(ChangeNotifierProvider(
    create: (context) => ToDoProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppRoutes(),
    );
  }
}
''';

  @override
  void initState() {
    super.initState();
    _initializeHighlighter();
  }

  // Initialize the highlighter asynchronously
  Future<void> _initializeHighlighter() async {
    var theme = await HighlighterTheme.loadDarkTheme();
    setState(() {
      highlighter = Highlighter(
        language: 'dart', // Set the language to Python or Dart as needed
        theme: theme,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Code Viewer'),
        ),
        body: highlighter == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  color: Colors.black,
                  child: SelectableText.rich(highlighter!.highlight(myCodeString),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        height: 1.5,
                        color: Colors.grey.shade100,
                      )),
                ),
              ) // Highlight the code
        );
  }
}

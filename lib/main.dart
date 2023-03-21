import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/theming/app_theme/lean_app_theme.dart';
import 'package:lean_ui_kit/theming/app_theme_access.dart';
import 'package:mind_base_manager/database/local_mind_base.dart';
import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/database/mind_base_md_converter_default.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/domain/use_cases/learning_tree_builder.dart';
import 'package:mind_base_manager/presentation/old_widgets/learning_tree_visual.dart';

import 'domain/entities/learning_goals_and_structures/learning_tree.dart';

Future<void> main() async {
  MindBase.init(LocalMindBase(
      "/Users/matthiasweigt/IdeaProjects/mind_base_manager/mind_bases/germany_school_math"));
  MindBaseMdConverter.init(MindBaseMdConverterDefault());
  AppThemeAccess.init(theme: LeanAppTheme());

  var m = await MindBase.instance.readAllLearningGoalsAsMap();

  LearningTree l = LearningTreeBuilder.build(LearningGoalCollection(m)
      .getAllDependentsOf(m.values
          .firstWhere((element) => element.id == "Auflösen - Quadratische Gleichung"))
      .values);

  // print(l);
  runApp(MyApp(learningTree: l));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.learningTree});

  final LearningTree learningTree;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true, brightness: Brightness.dark,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page', learningTree: learningTree),
    );
  }
}

// test
class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.learningTree});

  final LearningTree learningTree;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: LearningTreeVisualWidget(
            width: 1000, height: 700, learningTree: widget.learningTree),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

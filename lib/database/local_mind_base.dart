// @author Matthias Weigt 21.03.23

import 'dart:convert';
import 'dart:io';

import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/domain/entities/learning_goal.dart';
import 'package:mind_base_manager/domain/use_cases/stats_printer.dart';

class LocalMindBase extends MindBase{

  LocalMindBase(this.localMindBasePath);

  final String localMindBasePath;

  @override
  Future<LearningGoal> readLearningGoal(String id) async{

    File f = await openOrCreateFile("$localMindBasePath/$id.md");

    return MindBaseMdConverter.instance.fromMd(f.readAsLinesSync(),f.path.split("/").last);


  }


  Future<File> openOrCreateFile(String path) async {
    File? f;
    if(await File(path).exists()) {
      f = File(path);
    } else {
      f =await File(path).create(recursive: true);
    }
    return f;
  }


  Future<LearningGoal> _readLearningGoalFromPath(String path) async {
    File f = await openOrCreateFile(path);
    String s = f.path.split("/").last;
    String id = s.substring(0,s.length-3);
    return MindBaseMdConverter.instance.fromMd(f.readAsLinesSync(),id.replaceAll("ä", "ä").replaceAll("ö", "ö").replaceAll("ü", "ü"));
  }

  @override
  Future<List<LearningGoal>> readAllLearningGoals({bool printStats=true}) async {
    final List<LearningGoal> learningGoals = [];
    Stopwatch s = Stopwatch();
    s.start();
    final dir = Directory(localMindBasePath);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final Iterable<File> files = entities.whereType<File>();
    for(var v in files) {
      learningGoals.add(await _readLearningGoalFromPath(v.path));
    }
    StatsPrinter(title: "learning goals loaded", stats: [
      "total learningGoals: ${files.length}",
      "total loading time: ${s.elapsedMilliseconds/1000}s",
      "per file: ${(s.elapsedMilliseconds/files.length*100).round()/100}ms"
    ], doPrint: printStats);
    return learningGoals;
  }

  @override
  Future<Map<String,LearningGoal>> readAllLearningGoalsAsMap({bool printStats = false}) async {
    List<LearningGoal> learningGoals = await readAllLearningGoals(printStats: printStats);
    Map<String, LearningGoal> output = {};
    for(var v in learningGoals) {
        output[v.id] = v;
    }
    return output;
  }
}
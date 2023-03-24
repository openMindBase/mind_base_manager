// @author Matthias Weigt 21.03.23

import 'dart:io';

import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/domain/use_cases/stats_printer.dart';

class LocalMindBase extends MindBase {
  LocalMindBase(this.localMindBasePath);

  final String localMindBasePath;

  @override
  Future<LearningGoal> readLearningGoal(String id) async {
    File f = await openOrCreateFile("$localMindBasePath/$id.md");
    return MindBaseMdConverter.instance.fromMd(
        f.readAsLinesSync(), _removeDotMdFromString(f.path.split("/").last));
  }

  Future<File> openOrCreateFile(String path) async {
    File? f;
    if (await File(path).exists()) {
      f = File(path);
    } else {
      f = await File(path).create(recursive: true);
    }
    return f;
  }

  Future<LearningGoal> _readLearningGoalFromPath(String path) async {
    File f = await openOrCreateFile(path);
    String s = f.path.split("/").last;
    String id = _removeDotMdFromString(s);
    List<String> mdLines = f.readAsLinesSync();
    if(mdLines.isEmpty) {
      throw ArgumentError("$path does not exist");
    }
    return MindBaseMdConverter.instance.fromMd(mdLines,
        id.replaceAll("ä", "ä").replaceAll("ö", "ö").replaceAll("ü", "ü"));
  }

  String _removeDotMdFromString(String string) {
    if (string.contains(".md")) ;
    return string.substring(0, string.length - 3);
  }

  @override
  Future<List<LearningGoal>> readAllLearningGoals(
      {bool printStats = true}) async {
    final List<LearningGoal> learningGoals = [];
    Stopwatch s = Stopwatch();
    s.start();
    final dir = Directory(localMindBasePath);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final Iterable<File> files = entities.whereType<File>();
    for (var v in files) {
      if(v.path.contains("/.md")) {
        v.delete();
        continue;
      }
      learningGoals.add(await _readLearningGoalFromPath(v.path));
    }
    StatsPrinter(
        title: "learning goals loaded",
        stats: [
          "total learningGoals: ${files.length}",
          "total loading time: ${s.elapsedMilliseconds / 1000}s",
          "per file: ${(s.elapsedMilliseconds / files.length * 100).round() / 100}ms"
        ],
        doPrint: printStats);
    return learningGoals;
  }

  @override
  Future<Map<String, LearningGoal>> readAllLearningGoalsAsMap(
      {bool printStats = false}) async {
    List<LearningGoal> learningGoals =
        await readAllLearningGoals(printStats: printStats);
    Map<String, LearningGoal> output = {};
    for (var v in learningGoals) {
      output[v.id] = v;
    }
    return output;
  }

  @override
  Future<LearningGoalCollection> readAllLearningGoalsAsLearningGoalCollection(
      {bool printStats = false}) async {
    return LearningGoalCollection(
        await readAllLearningGoalsAsMap(printStats: printStats));
  }

  @override
  Future<void> addTagToLearningGoal(String id,String tag) async {
    LearningGoal learningGoal = await readLearningGoal(id);
    learningGoal.tags.add(tag);
    await writeLearningGoal(learningGoal);
  }

  @override
  Future<void> writeLearningGoal(LearningGoal learningGoal) async {
    File f =
        await openOrCreateFile("$localMindBasePath/${learningGoal.title}.md");
    f.writeAsString(
        MindBaseMdConverter.instance.learningGoalToMd(learningGoal));
  }
}

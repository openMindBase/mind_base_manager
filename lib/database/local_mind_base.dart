// @author Matthias Weigt 21.03.23

import 'dart:io';

import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/entities/persons/student_metadata.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/domain/use_cases/stats_printer.dart';

import '../domain/entities/learning_goals_and_structures/learning_tree.dart';

class LocalMindBase extends MindBase {
  LocalMindBase(this.localMindBaseDatabasePath) {
    //TODO: check if this conversion also holds on other os
    String s = localMindBaseDatabasePath.replaceAll("/", "\\").split("\\").last;
    s = localMindBaseDatabasePath.substring(
            0, localMindBaseDatabasePath.length - (s.length)) + testedDirectoryName;
    localMindBaseTestedStatePath = s;
  }

  static const String testedDirectoryName = "assessment_data";
  final String localMindBaseDatabasePath;
  late final String localMindBaseTestedStatePath;

  @override
  Future<LearningGoal> readLearningGoal(String id) async {
    File f = await openOrCreateFile("$localMindBaseDatabasePath/$id.md");
    return MindBaseMdConverter.instance.fromLearningGoalMd(
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

  Future<bool> _checkExistence(String path) async{
    if (await File(path).exists()){
      return true;
    }
    return false;
  }

  Future<LearningGoal> _readLearningGoalFromPath(String path) async {
    File f = await openOrCreateFile(path);
    String s = f.path.replaceAll("/", "\\").split("\\").last;
    String id = _removeDotMdFromString(s);
    List<String> mdLines = f.readAsLinesSync();
    if (mdLines.isEmpty) {
      throw ArgumentError("$path does not exist");
    }
    return MindBaseMdConverter.instance.fromLearningGoalMd(mdLines,
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
    final dir = Directory(localMindBaseDatabasePath);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final Iterable<File> files = entities.whereType<File>();
    for (var v in files) {
      if (v.path.contains("/.md")) {
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
  Future<void> addTagToLearningGoal(String id, String tag) async {
    LearningGoal learningGoal = await readLearningGoal(id);
    learningGoal.tags.add(tag);
    await writeLearningGoal(learningGoal);
  }

  @override
  Future<void> writeLearningGoal(LearningGoal learningGoal) async {
    File f = await openOrCreateFile(
        "$localMindBaseDatabasePath/${learningGoal.title}.md");
    f.writeAsString(
        MindBaseMdConverter.instance.learningGoalToMd(learningGoal));
  }

  @override
  Future<void> writeTestedTree(
      LearningTree lt,
      StudentMetadata metadata) async {
    File f;
    List<String>? mdAsLines = await readAssessmentData(metadata);

    if (mdAsLines==null){
      // does not exist => create file
      f = await openOrCreateFile(
          "$localMindBaseTestedStatePath/${metadata.name}_${metadata.id}.md");
      f.writeAsString(
          MindBaseMdConverter.instance.testedTreeToTreeCollectionMd(lt)
      );
    } else {
      String newline = "\n";
      // exists => open file
      f = await openOrCreateFile(
          "$localMindBaseTestedStatePath/${metadata.name}_${metadata.id}.md");
      String mdFile="";
      for (String line in mdAsLines){
        mdFile += line + newline;
      }

      f.writeAsString(
          MindBaseMdConverter.instance.testedTreeToTreeCollectionMd(lt,mdFile)
      );
    }

  }

  @override
  Future<List<String>?> readAssessmentData(StudentMetadata metadata) async{
    String path="$localMindBaseTestedStatePath/${metadata.name}_${metadata.id}.md";
    if (!(await _checkExistence(path))){
      return null;
    }
    // will definitely open something as we checked beforehand
    File f= await openOrCreateFile(path);
    return f.readAsLinesSync();
  }

}

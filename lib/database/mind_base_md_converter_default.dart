// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/domain/entities/exercise.dart';
import 'package:mind_base_manager/domain/entities/learning_goal.dart';

class MindBaseMdConverterDefault extends MindBaseMdConverter {
  @override
  LearningGoal fromMd(List<String> mdLines, String id) {
    List<String> dependents = [];
    List<String> tags = [];
    List<Exercise> exercises = [];
    bool isCollectionGoal = false;
    bool isOrGateway = false;
    bool shouldTest = false;
    bool singleExercise = false;
    String description = "";
    _readSection(mdLines, "##### Hard-Dependents", (s) {
      dependents.add(_obsidianDependencyStringToString(s));
    });
    _readSection(mdLines, "##### Tags", (s) {
      tags.add(_tagStringToString(s));
    });
    _readSection(mdLines, "##### Metadata", (s) {
      if (s.contains("isCollectionGoal")) {
        isCollectionGoal = _metaDataStringToBool(s);
      }
      if (s.contains("isOrGateway")) {
        isOrGateway = _metaDataStringToBool(s);
      }
      if (s.contains("shouldTest")) {
        shouldTest = _metaDataStringToBool(s);
      }
      if (s.contains("singleExercise")) {
        singleExercise = _metaDataStringToBool(s);
      }
    });

    _readSection(mdLines, "## Description", (s) {
      if (description.isNotEmpty) {
        description += "\n";
      }
      description += s;
    });

    if (mdLines.isNotEmpty) {
      String tempQuestion = "";
      String tempAnswer = "";
      bool isQuestionStringPart = true;
      _readSection(mdLines, "## Exercises", (s) {
        if (s.contains("#### Question")) {
          isQuestionStringPart = true;
          return;
        }
        if (s.contains("#### Answer")) {
          isQuestionStringPart = false;
          return;
        }
        if (s.contains("###")) {
          if (tempAnswer.isNotEmpty || tempQuestion.isNotEmpty) {
            exercises.add(Exercise(question: tempQuestion, answer: tempAnswer));
          }
          tempAnswer = "";
          tempQuestion = "";
          return;
        }
        if (isQuestionStringPart) {
          if (tempQuestion.isNotEmpty) {
            tempQuestion += "\n";
          }
          tempQuestion += s;
        } else {
          if (tempAnswer.isNotEmpty) {
            tempAnswer += "\n";
          }
          tempAnswer += s;
        }
      }, abortString: "#######");
      if (tempAnswer.isNotEmpty || tempQuestion.isNotEmpty) {
        exercises.add(Exercise(question: tempQuestion, answer: tempAnswer));
      }
    }

    return LearningGoal(
        id: id,
        exercises: exercises,
        description: description,
        dependents: dependents,
        isCollectionGoal: isCollectionGoal,
        isOrGateway: isOrGateway,
        shouldTest: shouldTest,
        singleExercise: singleExercise,
        tags: tags);
  }

  void _readSection(List<String> mdLines, String heading,
      void Function(String s) stringComputer,
      {String abortString = "##"}) {
    _checkForHeadingAndRemove(mdLines, heading);

    while (true) {
      if (mdLines.isEmpty || mdLines.first.contains(abortString)) {
        break;
      }
      stringComputer(mdLines.first);
      mdLines.removeAt(0);
    }
  }

  void _checkForHeadingAndRemove(List<String> mdLines, String heading) {
    if (!mdLines.first.contains(heading)) {
      throw ArgumentError(
          "md file seems to be formatted wrong. Expected $heading, found ${mdLines.first}");
    }
    mdLines.removeAt(0);
  }

  /// Converts " [[test]]" to "test".
  String _obsidianDependencyStringToString(String input) =>
      input.trim().replaceAll("[[", "").replaceAll("]]", "");

  /// Converts " [[test]]" to "test".
  String _tagStringToString(String input) => input.trim().replaceAll("#", "");

  bool _metaDataStringToBool(String input) =>
      input.split("=").last.trim() == "true" ? true : false;
}

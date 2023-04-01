// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/domain/entities/exercise.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/knowledge_state.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

import '../domain/entities/learning_goals_and_structures/learning_tree.dart';

class MindBaseMdConverterDefault extends MindBaseMdConverter {
  @override
  LearningGoal fromLearningGoalMd(List<String> mdLines, String id) {
    List<String> dependents = [];
    List<String> tags = [];
    List<Exercise> exercises = [];
    bool isCollectionGoal = false;
    bool isOrGateway = false;
    bool shouldTest = false;
    bool singleExercise = false;
    String description = "";
    _readSection(mdLines, "##### Hard-Dependents", (s) {
      if (s.isNotEmpty) {
        dependents.add(_obsidianDependencyStringToString(s));
      }
    });
    _readSection(mdLines, "##### Tags", (s) {
      if (s.isNotEmpty) {
        tags.add(_tagStringToString(s));
      }
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

  @override
  String learningGoalToMd(LearningGoal learningGoal) {
    String output = "";
    output = _addMarkdownSection("##### Hard-Dependents", output, (s) {
      for (int i = 0; i < learningGoal.dependents.length; i++) {
        if (i != 0) {
          s += "\n";
        }
        s += "[[${learningGoal.dependents[i]}]]";
      }
      s += "\n";
      return s;
    });
    output = _addMarkdownSection("##### Tags", output, (s) {
      for (int i = 0; i < learningGoal.tags.length; i++) {
        if (i != 0) {
          s += "\n";
        }
        s += "#${learningGoal.tags[i]}";
      }
      s += "\n";
      return s;
    });

    output = _addMarkdownSection("##### Metadata", output, (s) {
      s += "isCollectionGoal=${learningGoal.isCollectionGoal.toString()}";
      s += "\n";
      s += "isOrGateway=${learningGoal.isOrGateway.toString()}";
      s += "\n";
      s += "shouldTest=${learningGoal.shouldTest.toString()}";
      s += "\n";
      s += "singleExercise=${learningGoal.singleExercise.toString()}";
      s += "\n";
      return s;
    });
    output = _addMarkdownSection("## Description", output, (s) {
      s += learningGoal.description ?? "";
      s += "\n";
      return s;
    });
    if (learningGoal.exercises.isEmpty) {
      return output;
    }
    output = _addMarkdownSection("## Exercises", output, (s) {
      for (int i = 0; i < learningGoal.exercises.length; i++) {
        s = _addMarkdownSection("### ${i.toString()}", s, (s2) {
          s2 = _addMarkdownSection("#### Question", s2, (s3) {
            s3 += learningGoal.exercises[i].question;
            s3 += "\n";
            return s3;
          });
          s2 = _addMarkdownSection("#### Answer", s2, (s3) {
            s3 += learningGoal.exercises[i].answer;
            s3 += "\n";
            return s3;
          });
          return s2;
        });
      }
      return s;
    });
    return output;
  }

  @override
  /// TODO: implement correctly with many trees being collected and merged
  /// currently unused
  String mergeTestedCollections(
      String firstCollection, String secondCollection) {
    String output = "";
    String newline = "\n";
    String keyLGSection = "##### Key Learning Goals$newline";
    String improvableSection = "##### To be improved on Learning Goals$newline";
    String masteredSection = "##### Mastered Learning Goals$newline";
    List<String> l = [keyLGSection, improvableSection, masteredSection];

    List<String> allSectionsList =
        _splitCollectionBySections(firstCollection, l) +
            _splitCollectionBySections(secondCollection, l);
    assert(allSectionsList.length == 6);

    //check for duplicates and merge
    for (int i = 0; i < allSectionsList.length / 2; i++) {
      List<String> section = allSectionsList[i].split(newline) +
          allSectionsList[i + 3].split(newline);
      int j = 0;
      List<String> removeList=[];
      for (String line in section) {
        for (int k = j + 1; k < section.length; k++) {
          if (line == section[k]){
            removeList.add(line);
          }
        }
        j++;
      }
      //remove duplicates in section
      for (String toBeRemoved in removeList){
        section.remove(toBeRemoved);
      }
      //merge section into output again
      output += l[i];
      //is empty
      for (String s in section) {
        if (s==""){
          continue;
        }
        output += s + newline;
      }
    }

    print(output);

    return output;
  }

  @override
  String testedTreeToTreeCollectionMd(LearningTree lt,
      [String? mdFileAsString]) {
    String newline = "\n";
    String keyLGSection = "##### Key Learning Goals$newline";
    String improvableSection = "##### To be improved on Learning Goals$newline";
    String masteredSection = "##### Mastered Learning Goals$newline";

    for (LearningGoal c
        in lt.filter((learningGoal) => learningGoal.isControlled())) {
      masteredSection += c.title + newline;
    }
    for (LearningGoal i
        in lt.filter((learningGoal) => learningGoal.shouldBeImproved())) {
      improvableSection += _stringToObsidianDependencyString(i.title) + newline;
    }
    for (LearningGoal k
        in lt.filter((learningGoal) => lt.isKeyLearningGoal(learningGoal))) {
      keyLGSection += _stringToObsidianDependencyString(k.title) + newline;
    }

    String testedTree = keyLGSection + improvableSection + masteredSection;
    if (mdFileAsString != null) {
      //TODO: implement merging instead of overwriteting
      return testedTree;
    }
    return testedTree;
  }

  String _addMarkdownSection(
      String heading, String string, String Function(String s) stringComputer) {
    string += "$heading \n";
    string += stringComputer("");
    return string;
  }

  void _checkForHeadingAndRemove(List<String> mdLines, String heading) {
    if (!mdLines.first.contains(heading)) {
      throw ArgumentError(
          "md file seems to be formatted wrong. Expected $heading, found ${mdLines.first}");
    }
    mdLines.removeAt(0);
  }

  bool _metaDataStringToBool(String input) =>
      input.split("=").last.trim() == "true" ? true : false;

  /// Converts " [[test]]" to "test".
  String _obsidianDependencyStringToString(String input) =>
      input.trim().replaceAll("[[", "").replaceAll("]]", "");

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

  /// [listOfHeaders] is to be ordered by descending appearance in the collection
  /// a collection is formatted correctly if it has 3 categories
  List<String> _splitCollectionBySections(
      String collection, List<String> listOfHeaders) {
    assert (listOfHeaders.length == 3);
    List<String> output = [];
    output.add(collection.split(listOfHeaders[0]).last);
    output.addAll(output[0].split(listOfHeaders[1]));
    output.addAll(output[2].split(listOfHeaders[2]));
    output.removeAt(0);
    output.removeAt(1);
    return output;
  }

  /// Converts " test" to "[[test]]".
  String _stringToObsidianDependencyString(String input) {
    String s1 = "[[";
    String s2 = "]]";
    return s1 + input + s2;
  }

  String _tagStringToString(String input) => input.trim().replaceAll("#", "");

  @override
  String knowledgeStateToMd(KnowledgeState knowledgeState) {
    String output = "#totalKnowledgeState \n";
    output = _addMarkdownSection("# total knowledge State", output, (s) {
      s = _addMarkdownSection("## KeyLearningGoals", s, (s2) {
        for (LearningGoal lg in knowledgeState.keyLearningGoals) {
          s2 += _stringToObsidianDependencyString(lg.title);
          s2 += "\n";
        }
        return s2;
      });
      s = _addMarkdownSection("## improvement goals", s, (s2) {
        for (LearningGoal lg in knowledgeState.improvementGoals) {
          s2 += _stringToObsidianDependencyString(lg.title);
          s2 += "\n";
        }
        return s2;
      });
      s = _addMarkdownSection("## controlled learning goals", s, (s2) {
        for (LearningGoal lg in knowledgeState.controlledGoals) {
          s2 += learningGoalKnowledgeStateOfControlledToMd(lg);
        }
        return s2;
      });

      return s;
    });
    return output;
  }

  @override
  String learningGoalKnowledgeStateOfControlledToMd(LearningGoal learningGoal) {
    String output = "";
    output = _addMarkdownSection("### ${learningGoal.title}", output, (s) {
      s += "lastCorrectlyTested=${learningGoal.lastCorrectlyTested}\n";
      s +=
          "timesTestedCorrectlyStreak=${learningGoal.timesTestedCorrectlyStreak}\n";
      s +=
          "dependency=${_stringToObsidianDependencyString(learningGoal.title)}\n";
      return s;
    });
    return output;
  }
}

// @author Matthias Weigt 21.03.23

import '../exercise.dart';
import '../graphs/node.dart';

class LearningGoal extends Node{
  static const _isCollectionGoalDefault = false;
  static const _isOrGatewayDefault = false;
  static const _shouldTest = true;
  static const _singleExerciseDefault = false;
  static const double _defaultControlLevel = -1;

  LearningGoal(
      {required super.id,
      this.lastCorrectlyTested,
      this.timesTestedCorrectlyStreak = 0,
      String? title,
      this.description,
      this.isCollectionGoal = _isCollectionGoalDefault,
      this.isOrGateway = _isOrGatewayDefault,
      this.shouldTest = _shouldTest,
      this.singleExercise = _singleExerciseDefault,
      double? controlLevel,
      List<Exercise>? exercises,
      List<String>? dependents,
      List<String>? tags})
      : title = title ?? id,
        _controlLevel = controlLevel ?? _defaultControlLevel,
        exercises = exercises ?? [],
        dependents = dependents ?? [],
        tags = tags ?? [];


  /// The title of the [LearningGoal].
  /// If no title is given, [id] will be the title.
  final String title;

  /// If no [Exercise] is given, it often makes sense to give a description.
  final String? description;

  /// A collection goal, is a goal which is controlled, when all dependents are controlled.
  final bool isCollectionGoal;

  /// Some [LearningGoal]s are an OrGateway.
  /// Per default they are and AndGateway.
  final bool isOrGateway;

  /// Some [LearningGoal]s should not be tested.
  /// Mostly because they are collection goals.
  final bool shouldTest;

  /// Sometimes only one [Exercise] per [LearningGoal] makes sense.
  /// [singleExercise] determines if thats the case.
  final bool singleExercise;

  /// A list of [Exercise]es testing the controlLevel of the [LearningGoal].
  final List<Exercise> exercises;

  /// A list of tags, to determine the associations with the [LearningGoal].
  final List<String> tags;

  /// The learning dependents of this [LearningGoal].
  final List<String> dependents;

  bool _flagCanIncrementTimesTestedCorrectlyStreak = true;

  /// The date of the last test.
  DateTime? lastCorrectlyTested;

  /// The number of times this [LearningGoal] has been tested and controlled in a streak.
  int timesTestedCorrectlyStreak;

  /// -1 = [LearningGoal] has not been tested.
  /// 0 = [LearningGoal] has been tested but is not controlled.
  /// 1 = [LearningGoal] has been tested and is controlled.
  double _controlLevel;

  /// Use this methode to check if [LearningGoal] has been tested.
  bool isAlreadyTested() => controlLevel != _defaultControlLevel;

  /// Use this methode to check if [LearningGoal] has been tested and is controlled.
  bool isControlled() => controlLevel == 1;

  /// Some [LearningGoal]s are either controlled nor not controlled.
  /// There are somewhere in between.
  /// [shouldBeImproved] tells if this [LearningGoal] is one of them.
  bool shouldBeImproved() => controlLevel == 0.5;

  /// Sets [_controlLevel] for [LearningGoal] to: "has been tested and is controlled".
  void setAsControlled(
      {bool incrementTimesTestedCorrectly = true, int increment = 1}) {
    assignControlLevel(controlLevel: 1);
    _incrementCounter(increment: increment);
  }

  void _incrementCounter({int increment = 1}) {
    if (_flagCanIncrementTimesTestedCorrectlyStreak) {
      timesTestedCorrectlyStreak += increment;
      lastCorrectlyTested = DateTime.now();
      _flagCanIncrementTimesTestedCorrectlyStreak = false;
    }
  }

  /// Sets [_controlLevel] for [LearningGoal].
  /// If the [LearningGoal] is tested already, [level] won't be set.
  void assignControlLevel({required double controlLevel}) {
    if (isAlreadyTested()) {
      return;
    }
    _controlLevel = controlLevel;
  }

  /// Resets [_controlLevel] to: "has not been tested".
  void resetControlLevel() => _controlLevel = _defaultControlLevel;

  /// == can be used to consistently check the equality of two [LearningGoal]s.
  @override
  bool operator ==(covariant LearningGoal other) {
    return (other).id == id;
  }

  @override
  int get hashCode => id.hashCode;

  double get controlLevel => _controlLevel;

  // @override
  // String toString() {
  //   return 'LearningGoal{id: $id, title: $title, description: $description, isCollectionGoal: $isCollectionGoal, isOrGateway: $isOrGateway, shouldTest: $shouldTest, singleExercise: $singleExercise, exercises: $exercises, tags: $tags, dependents: $dependents, _controlLevel: $_controlLevel}';
  // }

  @override
  String toString() {
    return 'LearningGoal{title: $title}';
  }




  Exercise? randomExercise() {
    //todo 23.03.23 17:18 von @Matthias implement me correct.
    if(exercises.isNotEmpty) {
      return exercises[0];
    }
    return null;
  }


}

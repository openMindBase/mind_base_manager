// @author Matthias Weigt 21.03.23

import 'learning_goal.dart';
import '../math/polar_coordinates.dart';
import '../math/tuple.dart';
import 'learning_tree_signature.dart';

class LearningTreeCoordinatesGenerator {
  LearningTreeCoordinatesGenerator(this.learningTree,
      {this.drawAngleMax = 150,
        this.radius = 100,
        this.xOffset = 0,
        this.yOffset = 0,
        this.drawAngleMin = 60})
      : drawAngleDiff = drawAngleMax - drawAngleMin;

  /// The signature of a [LearningTree].
  final LearningTreeSignature? learningTree;

  /// The angle upward to place the [LearningGoal]s on.
  final int drawAngleMax;

  final int drawAngleMin;

  final int drawAngleDiff;

  /// The radius between each grade circle.
  final int radius;

  final double xOffset;
  final double yOffset;

  /// Key: The id of a [LearningGoal]
  /// Value: The coordinates of the [LearningGoal]
  Map<String, PolarCoordinates> getPolar() {
    Map<String, PolarCoordinates> output = {};
    if(learningTree==null) {
      return output;
    }
    int maxGrade = learningTree!.learningGoalsByGrade.length - 1;
    for (int i = maxGrade; i >= 0; i--) {
      final List<LearningGoal> tempLearningGoals =
      learningTree!.learningGoalsByGrade[i]!;
      final int tempLearningGoalCount = tempLearningGoals.length;
      final int tempDrawAngle = drawAngleMin +
          (drawAngleDiff * ((maxGrade - i - 1) / maxGrade)).toInt();
      final double startAngle = -tempDrawAngle / 2;
      final double stepSize = tempDrawAngle / (tempLearningGoalCount - 1);
      for (int k = 0; k < tempLearningGoalCount; k++) {
        final double tempAngle =
        tempLearningGoalCount == 1 ? 0 : startAngle + (k * stepSize);
        final int tempRadius = (maxGrade - i) * radius;
        output[tempLearningGoals[k].id] =
            PolarCoordinates(radius: tempRadius.toDouble(), angle: tempAngle);
      }
    }
    return output;
  }

  Map<String, Tuple<double>> getCartesian() {
    Map<String, Tuple<double>> output = {};
    Map<String, PolarCoordinates> polars = getPolar();
    for (var key in polars.keys) {
      PolarCoordinates polar = polars[key]!;
      output[key] = polar.toCartesian(xOffset: xOffset, yOffset: yOffset);
    }
    return output;
  }
}
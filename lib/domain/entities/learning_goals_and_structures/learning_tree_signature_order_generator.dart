// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'learning_goal.dart';
import 'learning_tree_signature.dart';

class LearningTreeSignatureOrderGeneratorV1
    extends LearningTreeSignatureOrderGenerator {
  @override
  LearningTreeSignature get(LearningTreeSignature signature,
      {double maxTries = 10000,LearningTreeSignature? bestSignature}) {
    if (signature.learningGoalsByGrade.length == 1) {
      return signature;
    }

    int grade = signature.learningGoalsByGrade.length-2;
    int listIndex = 0;
    double bestLength = signature.computeAmount();
    while(true) {
      maxTries--;
      if(maxTries<=0) {
        if(bestSignature!=null) {
          if(bestSignature.computeAmount()<bestLength) {
            return bestSignature;
          }
        }
        return signature;
      }
      if(grade==0 && listIndex==goalsByGrade(grade, signature).length-1) {
        if(bestSignature!=null) {
          if(bestSignature.computeAmount()<bestLength) {
            return get(signature.shuffle(),maxTries: maxTries,bestSignature: bestSignature.computeAmount()<bestLength?bestSignature:signature);
          }
        }
        return get(signature.shuffle(),bestSignature: signature,maxTries: maxTries);
      }
      if(listIndex==goalsByGrade(grade, signature).length-1) {
        grade--;
        listIndex=0;
        continue;
      }
      var tempSignature = signature.swap(grade: grade, pos1: listIndex, pos2: listIndex+1);
      double potLength = tempSignature.computeAmount();
      if(potLength < bestLength) {
        bestLength = potLength;
        signature = tempSignature;
        grade = signature.learningGoalsByGrade.length-2;
        listIndex = 0;
        continue;
      }


      listIndex++;
    }





    // Set<_Tripel> allOptions(LearningTreeSignature signature) {
    //   Set<_Tripel> output={};
    //   for(int grade in signature.learningGoalsByGrade.keys) {
    //
    //     List<LearningGoal> tempGoals = signature.learningGoalsByGrade[grade]!;
    //     for(int i = 0;i<tempGoals.length;i++) {
    //       for(int k = 0;k<tempGoals.length;k++) {
    //
    //       }
    //     }
    //     output.add(_Tripel(grade: grade, pos1: pos1, pos2: pos2))
    //
    //   }
  }

  List<LearningGoal> goalsByGrade(int grade,LearningTreeSignature signature) {
    return signature.learningGoalsByGrade[grade] as List<LearningGoal>;
  }
}

abstract class LearningTreeSignatureOrderGenerator {
  static LearningTreeSignatureOrderGenerator current =
      LearningTreeSignatureOrderGeneratorV1();

  LearningTreeSignature get(LearningTreeSignature signature, {double maxTries});
}


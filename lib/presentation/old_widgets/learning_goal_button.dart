// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_text_button.dart';

import '../../domain/entities/learning_goals_and_structures/learning_goal.dart';

class LearningGoalButton extends StatelessWidget {
  const LearningGoalButton(
      {super.key,
      required this.learningGoal,
      required this.learningGoalCallback});

  final LearningGoal learningGoal;

  final LearningGoalCallback learningGoalCallback;

  @override
  Widget build(BuildContext context) {

    // return OutlinedButton(onPressed: () {
    //   learningGoalCallback(learningGoal);
    // }, child: Text(learningGoal.title,style: Theme.of(context).textTheme.bodyLarge,));

    return InkWell(
      child: Card(elevation: 1,borderOnForeground: true,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black
                //todo 21.03.23 16:13 von @Matthias
            // side: BorderSide(color: MyApp.of(context).darkMode?Colors.white:Colors.black
            ),
            borderRadius: BorderRadius.circular(10), //<-- SEE HERE
          ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(learningGoal.title,style: Theme.of(context).textTheme.bodyLarge,),
        ),
      ),
      onTap: () {
        learningGoalCallback(learningGoal);
      },
    );
  }
}

typedef LearningGoalCallback = void Function(LearningGoal learningGoal);

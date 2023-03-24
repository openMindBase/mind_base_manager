// @author Matthias Weigt 24.03.23


import 'package:mind_base_manager/database/local_mind_base.dart';
import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/use_cases/stats_printer.dart';

import '../learning_goal_collection.dart';

/// Sometimes the tags of the [LearningGoal]s within a mind-base, are not set correctly.
/// The [MindBaseTagger] adds tags to dependent [LearningGoal]s of other tags.
class MindBaseTagger{

  MindBaseTagger({required this.mindBasePath});

  final String mindBasePath;
  bool shouldReloadLearningGoals = true;
  Future<LearningGoalCollection>? learningGoalCollection;

  Future<void> updateAllTags() async {
    LearningGoalCollection learningGoalCollection = await openLearningGoalCollection();
    for(var tag in learningGoalCollection.tags()) {
        await tagSpecificTag(tag);
    }
  }

  Future<void> tagSpecificTag(String tag) async {
    if(tag=="root") {
      return;
    }
    LearningGoalCollection learningGoalCollection = await openLearningGoalCollection();
    learningGoalCollection = learningGoalCollection.filterByTag(tag);
    bool tagFlag = false;
    for(var v in learningGoalCollection.learningGoalMap.values) {
        for(var dependent in v.dependents) {
            if(learningGoalCollection.containsTitle(dependent)) {
              continue;
            }
            StatsPrinter(title: "tag added", stats: ["Tag $tag added to $dependent"]).printStats();
            await MindBase.instance.addTagToLearningGoal(dependent,tag);
            shouldReloadLearningGoals = true;
            tagFlag = true;
        }
    }
    if(tagFlag) {
      return tagSpecificTag(tag);
    }
  }


  Future<LearningGoalCollection> openLearningGoalCollection() {
    MindBase.init(LocalMindBase(mindBasePath));
    if(shouldReloadLearningGoals || learningGoalCollection==null) {
      shouldReloadLearningGoals=false;
      learningGoalCollection = MindBase.instance.readAllLearningGoalsAsLearningGoalCollection();
    }
    return learningGoalCollection!;
  }



}
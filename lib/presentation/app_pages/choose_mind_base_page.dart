// @author Matthias Weigt 23.03.23

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_text_field.dart';
import 'package:mind_base_manager/presentation/app_pages/tag_selection_page.dart';
import 'package:mind_base_manager/presentation/other/future_page_navigator.dart';

import '../../database/local_mind_base.dart';
import '../../database/mind_base.dart';
import '../../domain/entities/persons/student_metadata.dart';
import '../../domain/use_cases/learning_goal_collection.dart';
import 'app_page.dart';

class ChooseMindBasePage extends StatelessWidget {
  static OnMindBasePathSelect openTagSelectionPage(
      {required BuildContext context,
      required StudentMetadata metadata,
      required OnTagSelect onTagSelect}) {
    return (mindBasePath) {
      MindBase.init(LocalMindBase(pathRoot: mindBasePath));

      FuturePageNavigator<LearningGoalCollection>().push(
        future: MindBase.instance
            .readAllLearningGoalsAsLearningGoalCollectionWithKnowledgeState(
                printStats: true, metadata: metadata),
        context: context,
        builder: (context, data) {
          return TagSelectionPage(
            learningGoalCollection: data,
            onTagPressed: onTagSelect,
          );
        },
      );
    };
  }

  ChooseMindBasePage({super.key, required this.onMindBasePathChoose});

  final TextEditingController pathController = TextEditingController();

  final void Function(String mindBasePath) onMindBasePathChoose;

  @override
  Widget build(BuildContext context) {
    return AppPage(title: "Choose the folder path of your mindbase", children: [
      const Text(
          "submitting with an empty path will lead to mind_bases/germany_school_math"),
      SizedBox(
        width: 750,
        child: LeanTextField(
          controller: pathController,
          hintText: "path",
        ),
      ),
      ElevatedButton(
          onPressed: () => _onClickSubmit(context), child: const Text("submit"))
    ]);
  }

  void _onClickSubmit(BuildContext context) {
    onMindBasePathChoose(
      pathController.text.isEmpty
          ? "mind_bases/germany_school_math"
          : pathController.text,
    );
  }
}

typedef OnMindBasePathSelect = void Function(String mindBasePath);

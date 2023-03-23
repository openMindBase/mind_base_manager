// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';

import '../../domain/entities/learning_goals_and_structures/learning_tree.dart';
import '../../domain/entities/persons/student_metadata.dart';
import '../../domain/use_cases/test_procedures/test_procedure_v1.dart';
import '../widgets/test_procedure/test_procedure_widget_v1.dart';
import 'app_page.dart';


typedef TestedLearningTreeCallback = void Function(LearningTree learningTree);

class TestProcedurePage extends StatelessWidget {
  const TestProcedurePage(
      {super.key,
      required this.learningTree,
      required this.title,
      required this.onTestingComplete,
      required this.studentMetadata});

  final LearningTree learningTree;
  final String title;
  final TestedLearningTreeCallback onTestingComplete;
  final StudentMetadata studentMetadata;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: title,
      showBackButton: true,
      children: [
        TestProcedureWidgetV1(
        testProcedure: TestProcedureV1(learningTree),
    onTestingComplete: onTestingComplete,
    studentMetadata: studentMetadata,
    )
      ],
    );
  }
}

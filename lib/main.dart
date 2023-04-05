import 'package:flutter/material.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';
import 'package:lean_ui_kit/theming/app_theme/lean_app_theme.dart';
import 'package:lean_ui_kit/theming/app_theme_access.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/database/mind_base_md_converter_default.dart';
import 'package:mind_base_manager/presentation/app_pages/choose_mind_base_page.dart';
import 'package:mind_base_manager/presentation/app_pages/input_student_metadata.dart';
import 'package:mind_base_manager/presentation/app_pages/tag_selection_page.dart';
import 'package:mind_base_manager/presentation/app_pages/test_procedure_page.dart';
import 'package:mind_base_manager/presentation/other/future_page_navigator.dart';

import 'database/local_mind_base.dart';
import 'database/mind_base.dart';
import 'domain/use_cases/learning_goal_collection.dart';

Future<void> main() async {
  _init();
  runApp(const MindBaseApp());
}

/// Some parts have to be initialized.
/// In here its done.
void _init() {
  MindBaseMdConverter.init(MindBaseMdConverterDefault());
  AppThemeAccess.init(theme: LeanAppTheme());
}

/// The primary class representing the [MindBaseApp].
class MindBaseApp extends StatelessWidget {
  const MindBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindBase',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      home: const MindBaseHomePage(),
    );
  }
}

class MindBaseHomePage extends StatelessWidget {
  const MindBaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // describes sequence of pages being walked through
        // when whole application functionality is used:
        body: InputStudentMetadataPage(
      onSubmitMetadata: (metadata) async {
        LeanNavigator.pushPage(context,
            ChooseMindBasePage(onMindBasePathChoose: (mindBasePath) {
          MindBase.init(LocalMindBase(pathRoot: mindBasePath));

          FuturePageNavigator<LearningGoalCollection>().push(
            future: MindBase.instance
                .readAllLearningGoalsAsLearningGoalCollectionWithKnowledgeState(
                    printStats: true, metadata: metadata),
            context: context,
            builder: (context, data) {
              return TagSelectionPage(
                learningGoalCollection: data,
                onTagPressed: (tag, collection) {
                  LeanNavigator.pushPage(
                      context,
                      TestProcedurePage(
                          learningTree: collection.getLearningTree(),
                          title: "#$tag",
                          onTestingComplete: (learningTree) {},
                          studentMetadata: metadata));
                },
              );
            },
          );
        }));
      },
    ));
  }
}

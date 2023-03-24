import 'package:flutter/material.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';
import 'package:lean_ui_kit/theming/app_theme/lean_app_theme.dart';
import 'package:lean_ui_kit/theming/app_theme_access.dart';
import 'package:mind_base_manager/database/local_mind_base.dart';
import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/database/mind_base_md_converter.dart';
import 'package:mind_base_manager/database/mind_base_md_converter_default.dart';
import 'package:mind_base_manager/domain/entities/persons/student_metadata.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/domain/use_cases/mind_base_modifier/mind_base_tagger.dart';
import 'package:mind_base_manager/presentation/app_pages/choose_mind_base_page.dart';
import 'package:mind_base_manager/presentation/app_pages/loading_page.dart';
import 'package:mind_base_manager/presentation/app_pages/tag_selection_page.dart';
import 'package:mind_base_manager/presentation/app_pages/test_procedure_page.dart';

Future<void> main() async {
  _init();
  await MindBaseTagger(mindBasePath: "/Users/matthiasweigt/IdeaProjects/mind_base_manager/mind_bases/germany_school_math").updateAllTags();
  runApp(const MindBaseApp());
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
      body: ChooseMindBasePage(
        onMindBasePathChoose: (mindBasePath) async {
          MindBase.init(LocalMindBase(mindBasePath));

          LeanNavigator.push(
              context,
              FutureBuilder<LearningGoalCollection>(
                  future: MindBase.instance
                      .readAllLearningGoalsAsLearningGoalCollection(
                          printStats: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<LearningGoalCollection> snapshot) {
                    if (!snapshot.hasData) {
                      return const LoadingPage();
                    }
                    var data = snapshot.data as LearningGoalCollection;
                    return TagSelectionPage(
                      learningGoalCollection: data,
                      onTagPressed: (tag, collection) {
                        LeanNavigator.push(
                            context,
                            TestProcedurePage(
                                learningTree: collection.getLearningTree(),
                                title: "#$tag",
                                onTestingComplete: (learningTree) {},
                                studentMetadata:
                                    const StudentMetadata("Mira Bellenbaum")),
                            includeScaffold: true);
                      },
                    );
                  }),
              includeScaffold: true);
        },
      ),
    );
  }
}

/// Some parts have to be initialized.
/// In here its done.
void _init() {
  MindBaseMdConverter.init(MindBaseMdConverterDefault());
  AppThemeAccess.init(theme: LeanAppTheme());
}

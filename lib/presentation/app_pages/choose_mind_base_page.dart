// @author Matthias Weigt 23.03.23



import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_text_field.dart';

import 'app_page.dart';


class ChooseMindBasePage extends StatelessWidget {
  ChooseMindBasePage({super.key, required this.onMindBasePathChoose});
  final TextEditingController pathController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();

  final void Function(String mindBasePath, String testedName) onMindBasePathChoose;
  @override
  Widget build(BuildContext context) {
    return AppPage(
        title: "Choose the folder path of your mindbase", children: [
          const Text(
            "submitting with an empty path will lead to mind_bases/germany_school_math/germany_school_math_database"
          ),
          SizedBox(
              width: 750,
              child: LeanTextField(
                controller: pathController,
                hintText: "path",
              ),
          ),
          SizedBox(
            width: 750,
            child: LeanTextField(
              controller: studentNameController,
              hintText: "name of tested person",
            ),
          ),
          ElevatedButton(onPressed: () => _onClickSubmit(context), child: const Text("submit"))
        ]
    );
  }


  void _onClickSubmit(BuildContext context) {
    onMindBasePathChoose(
        pathController.text.isEmpty?"mind_bases/germany_school_math/germany_school_math_database":pathController.text,
        studentNameController.text.isEmpty?"genericTestedPerson":studentNameController.text
    );
  }
}
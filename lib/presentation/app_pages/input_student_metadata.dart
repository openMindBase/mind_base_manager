// @author Yuri Hassink & Matthias Weigt 28.03.23

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_text_field.dart';
import 'package:mind_base_manager/domain/entities/persons/student_metadata.dart';

import '../../domain/entities/random/random_generators.dart';
import 'app_page.dart';

class InputStudentMetadataPage extends StatelessWidget {
  InputStudentMetadataPage({super.key, required this.onSubmitMetadata});

  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController idNameController = TextEditingController();

  final void Function(StudentMetadata metadata) onSubmitMetadata;

  @override
  Widget build(BuildContext context) {
    return AppPage(title: "Create or Retrieve Testing Profile", children: [
      const Text(
          "(optional) give a name under which should be testing should be saved"),
      SizedBox(
        width: 750,
        child: LeanTextField(
          controller: studentNameController,
          hintText: "name of tested person",
        ),
      ),
      const Text(
          "Submitting with an empty ID will generate one randomly and save tests under that id."),
      const Text(
          "It will then put it in your clipboard (ctrl + v) to save it on your computer locally somewhere."),
      const Text(" "),
      const Text(
          "If you have a generated ID paste it in here to save your progress from test to test:"),
      SizedBox(
        width: 750,
        child: LeanTextField(
          controller: idNameController,
          hintText: "20 character long ID",
        ),
      ),
      ElevatedButton(
          onPressed: () => _onClickSubmit(context), child: const Text("submit"))
    ]);
  }

  void _onClickSubmit(BuildContext context) {
    if (idNameController.text.length < 20 &&
        idNameController.text.length != 0) {
      throw Exception("invalid id!");
    }
    String id = "";
    if (idNameController.text.isEmpty) {
      id = RandomHashGenerator().toString();
      Clipboard.setData(ClipboardData(text: id));
    } else {
      id = idNameController.text;
    }
    print("generated id:");
    print(id);

    onSubmitMetadata(StudentMetadata(id,
        name: studentNameController.text.isEmpty
            ? "DemoTestedPerson"
            : studentNameController.text));
  }
}
